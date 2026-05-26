# Thiết kế Hệ thống (Tiêu chí 3)

## 1. Kiến trúc tổng quan

Hệ thống sử dụng Firestore làm cơ sở dữ liệu NoSQL cloud cho các dữ liệu cần đồng bộ giữa thiết bị. Hive được dùng như local cache và local-only storage để hỗ trợ offline fallback, session, theme, cart và favorites.

- Không dùng Firebase Auth native. User đăng nhập bằng số điện thoại và password custom.
- Admin đăng nhập bằng email qua cổng riêng `AdminAuthService`.
- Ứng dụng không sử dụng realtime stream của Firestore để tiết kiệm băng thông. Việc đồng bộ dữ liệu cloud (Cloud Sync) được thực hiện qua các lệnh fetch, manual sync, hoặc Pull-to-refresh.

```mermaid
flowchart TD
    UI[Flutter UI Screens] --> P[Providers]
    P --> S[Services]
    S --> F[(Firebase Firestore \n Cloud NoSQL)]
    S --> H[(Hive \n Local Cache / Storage)]
```

## 2. Class Diagram

```mermaid
classDiagram
    %% Models
    class UserModel {
        +String id
        +String name
        +String phone
        +String email
        +String dob
        +String passwordHash
        +String avatarPath
        +DateTime createdAt
    }
    class ProductModel {
        +int id
        +String name
        +String category
        +int price
        +double rating
        +String imagePath
        +String description
    }
    class AdminProductModel {
        +int id
        +String name
        +String description
        +int price
        +String category
        +String imagePreset
        +bool isActive
    }
    class CartItemModel {
        +int productId
        +int quantity
        +int price
    }
    class OrderItemModel {
        +int productId
        +String name
        +int quantity
        +int price
    }
    class OrderModel {
        +String id
        +String userId
        +List~OrderItemModel~ items
        +int totalAmount
        +int discount
        +String deliveryAddress
        +String note
        +String paymentMethod
        +String status
        +DateTime createdAt
    }
    class VoucherModel {
        +String id
        +String code
        +int discountPercentage
        +bool isActive
    }

    %% Providers
    class AuthProvider
    class ProductProvider
    class CartProvider
    class OrderProvider

    %% Services
    class AuthService
    class AdminAuthService
    class ProductService
    class AdminProductService
    class CartService
    class OrderService
    class AdminOrderReadService
    class DatabaseService

    %% DB Notes
    class Firestore
    class Hive

    %% Relations Models
    CartItemModel --> ProductModel
    OrderModel --> OrderItemModel
    
    %% Relations Provider-Service
    AuthProvider --> AuthService
    ProductProvider --> ProductService
    CartProvider --> CartService
    OrderProvider --> OrderService
    
    %% Relations Service-Service
    ProductService --> AdminProductService
    AdminOrderReadService --> OrderModel
    
    %% Relations Service-DB
    AuthService ..> Firestore
    AuthService ..> Hive
    CartService ..> Hive
    OrderService ..> Firestore
    AdminProductService ..> Firestore
    ProductService ..> Hive
```

## 3. Activity Diagrams

**1. User Register/Login**
```mermaid
flowchart TD
    Start([Start]) --> Check{Đã có Session Hive?}
    Check -- Yes --> Home([Go to Home])
    Check -- No --> Auth[Màn hình Đăng nhập / Đăng ký]
    Auth --> Input[Nhập Số điện thoại & Password]
    Input --> CallAuth[AuthService gọi Firestore]
    CallAuth --> Valid{Hợp lệ?}
    Valid -- No --> Err[Báo lỗi UI] --> Input
    Valid -- Yes --> SaveSession[Lưu Session vào Hive cache]
    SaveSession --> Home
```

**2. User Browse -> Product Detail -> Cart -> Checkout -> Create Order**
```mermaid
flowchart TD
    Start([Home Screen]) --> Browse[Browse ProductList]
    Browse --> Click[Chọn sản phẩm]
    Click --> Detail[Xem Chi tiết Sản phẩm]
    Detail --> AddCart[Thêm vào Giỏ hàng Local Hive]
    AddCart --> Cart[Mở Giỏ hàng]
    Cart --> Checkout[Checkout & Apply Voucher]
    Checkout --> Create[OrderService tạo Order Firestore]
    Create --> ClearCart[Clear Local Hive Cart]
    ClearCart --> Done([Order Success])
```

**3. Admin Add/Edit/Hide Product -> Firestore -> User Pull-to-refresh**
```mermaid
flowchart TD
    Start([Admin Dashboard]) --> Form[Điền Form Thêm/Sửa/Ẩn Sản phẩm]
    Form --> SaveAdmin[AdminProductService cập nhật lên Firestore]
    SaveAdmin --> DoneAdmin([Cập nhật thành công])
    
    StartUser([User Home Screen]) --> Pull[User Pull-to-refresh]
    Pull --> FetchUser[ProductService fetch từ Firestore]
    FetchUser --> Cache[Lưu đè vào Hive Cache]
    Cache --> ShowUI([Hiển thị Sản phẩm mới/cập nhật])
```

**4. Admin Orders -> Pull-to-refresh -> Update Status**
```mermaid
flowchart TD
    Start([Admin Orders Screen]) --> Pull[Admin Pull-to-refresh]
    Pull --> Fetch[AdminOrderReadService fetch Orders từ Firestore]
    Fetch --> Select[Chọn đơn hàng chờ xử lý]
    Select --> UpdateStatus[Đổi trạng thái sang Processing/Delivered]
    UpdateStatus --> SaveSync[Cập nhật lên Firestore]
    SaveSync --> Done([Refresh lại danh sách])
```

## 4. Flowchart luồng chức năng chính

```mermaid
flowchart TD
    subgraph GUEST [Guest Flow]
        G[Mở App] --> O[Onboarding]
        O --> L[Login / Register]
    end

    subgraph USER [User Flow]
        H[Home / Explore] --> PD[Product Detail]
        PD --> C[Local Cart]
        H --> C
        C --> CH[Checkout]
        CH --> O_USER[Orders / Tracking]
    end

    subgraph ADMIN [Admin Flow]
        AL[Admin Login Portal] --> DB[Dashboard]
        DB --> PM[Products Management]
        DB --> OM[Orders Management]
    end

    L --> H
    
    %% Sync Points
    S_F[(Firestore Sync Point)]
    S_H[(Hive Local Cache/Offline Point)]

    CH -. sync .-> S_F
    PM -. CRUD .-> S_F
    OM -. pull/update .-> S_F
    O_USER -. pull-to-refresh .-> S_F
    L -. login data .-> S_F

    C -. save only .-> S_H
    H -. cache fallback .-> S_H
```

## 5. Database Design - Firebase Firestore và Hive

### 5.1 Firebase Firestore Cloud NoSQL
Đây là cơ sở dữ liệu cloud chính yếu của ứng dụng phục vụ lưu trữ, chia sẻ và đồng bộ dữ liệu giữa các máy khách và quản trị viên.

- **Collection `users`:**
  - **Document ID:** SĐT của user (phone).
  - **Fields:** `id`, `name`, `phone`, `email`, `dob`, `passwordHash`, `avatarPath`, `createdAt`.
  - **Vai trò:** Đồng bộ tài khoản người dùng với hệ thống xác thực tuỳ chỉnh (Custom Auth). Hệ thống không sử dụng Firebase Auth.
- **Collection `products`:**
  - **Vai trò:** Danh mục món ăn dùng chung và global, được seed sẵn vào db.
  - **Fields:** `id`, `name`, `category`, `price`, `rating`, `imagePath`, `description`.
- **Collection `orders`:**
  - **Document ID:** Tự tạo ngẫu nhiên (UUID hoặc Firestore autoid).
  - **Fields:** `id`, `userId`, `items` (Array), `totalAmount`, `discount`, `deliveryAddress`, `note`, `paymentMethod`, `status`, `createdAt`.
  - **Vai trò:** Đồng bộ hóa đơn đặt món từ user để admin xử lý.
- **Collection `admin_products`:**
  - **Document ID:** ID string của sản phẩm.
  - **Fields:** `id`, `name`, `category`, `price`, `description`, `imagePreset`, `isActive`.
  - **Vai trò:** Chứa danh sách các món ăn do Admin thêm, sửa hoặc ẩn hiện. User khi refresh trang sẽ nhận dữ liệu từ đây.

### 5.2 Hive Local Cache / Local-only Storage
Hive đóng vai trò vô cùng quan trọng như một Local Cache (bộ nhớ tạm) và Local-only Storage, hỗ trợ mạnh mẽ khả năng offline-first của app mobile.

- **Local-only Storage:**
  - `cart`: Lưu các món ăn trong giỏ hàng hoàn toàn offline để phản hồi tức thì, không đồng bộ cloud cho đến lúc checkout.
  - `favorites`: Danh sách món yêu thích lưu cục bộ.
  - `theme/settings`: Sở thích cài đặt của người dùng.
- **Local Cache (Fallback):**
  - `session`: Lưu trạng thái đăng nhập để tự động vào Home, tránh login lại nhiều lần.
  - `products cache`, `orders cache`: Khi mất mạng hoặc server lỗi, Service sẽ đọc Hive fallback để hiển thị UI thay vì báo lỗi trắng màn hình.

## 6. Data Flow / Sync Flow

- **Product Sync Flow:**
  `Firestore` -> `ProductService` (hoặc `AdminProductService`) -> `Hive Cache` (ghi đề) -> `ProductProvider` -> `UI`.
- **Order Sync Flow:**
  User checkout -> `OrderService` lưu vào `Hive` (local) + Đẩy lên `Firestore` (best-effort) -> Admin pull-to-refresh -> `AdminOrderReadService` fetch từ Firestore -> Lưu `Hive` cache -> Báo UI hiển thị.
- **Offline Fallback Flow:**
  Yêu cầu `Firestore` thất bại (hoặc không có mạng) -> Bắt Exception -> Service đọc dữ liệu dự phòng từ `Hive` -> `Provider` -> Vẫn hiển thị được `UI`.
