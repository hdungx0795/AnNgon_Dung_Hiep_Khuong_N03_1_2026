# User Stories (Tiêu chí 1)

Tài liệu này định nghĩa các User Stories cho hệ thống PKA Food, bao phủ tất cả các tính năng cần thiết cho hai vai trò chính: Người dùng (User) và Quản trị viên (Admin).

## 1. Người dùng (User/Customer)

### Onboarding, Đăng ký & Đăng nhập
- **US1.1:** As a guest, I want to see an onboarding screen so that I can understand the app's main features before using it.
- **US1.2:** As a guest, I want to register for a new account using my phone number and password so that I can start ordering food.
- **US1.3:** As a user, I want to log in using my phone number and password so that I can access my profile, cart, and order history safely without standard Firebase Auth emails.
- **US1.4:** As a user, I want to log out securely so that my account remains safe when I am not using the app.

### Duyệt, Tìm kiếm & Lọc Sản phẩm
- **US2.1:** As a user, I want to view a list of featured and popular food items on the home screen so that I can quickly decide what to order.
- **US2.2:** As a user, I want to search for specific food items by name so that I can find exactly what I am craving.
- **US2.3:** As a user, I want to filter products by categories (e.g., Fast Food, Drinks, Desserts) so that I can easily browse options that fit my preferences.
- **US2.4:** As a user, I want to add products to my Favorites list (stored locally on device) so that I can re-order them quickly later.
- **US2.5:** As a user, I want to view the detailed information of a specific product so that I can make an informed purchasing decision.

### Giỏ hàng, Thanh toán & Theo dõi Đơn hàng
- **US3.1:** As a user, I want to add products to my local cart with specific quantities so that I can order multiple items offline-first without lag.
- **US3.2:** As a user, I want to view and edit my cart (update quantities or remove items) before proceeding to checkout.
- **US3.3:** As a user, I want to apply a discount voucher to my cart so that I can get a reduced total price before checkout.
- **US3.4:** As a user, I want to choose a payment method (COD or Bank Transfer/QR) so that I can pay conveniently.
- **US3.5:** As a user, I want to confirm my order and have it synced to the cloud so that the restaurant receives it.
- **US3.6:** As a user, I want to view my order history by pulling down to refresh so that I can get the latest status from the cloud.

## 2. Quản trị viên (Admin)

### Đăng nhập & Dashboard
- **US4.1:** As an admin, I want to log in using a dedicated Admin Authentication Portal so that I am completely isolated from standard users.
- **US4.2:** As an admin, I want to see an overview of key metrics (total orders, total revenue, pending orders) on my dashboard so that I can monitor the business performance.

### Quản lý Sản phẩm
- **US5.1:** As an admin, I want to fetch and view the list of all products in the system by pulling down to refresh.
- **US5.2:** As an admin, I want to add new products (name, description, price, category) so that customers have more options.
- **US5.3:** As an admin, I want to edit existing product details (price, name, description) so that I can keep the catalog up to date.
- **US5.4:** As an admin, I want to toggle the active status of products (isActive) so that I can temporarily hide items that are out of stock.

### Quản lý Đơn hàng
- **US6.1:** As an admin, I want to view a list of all user orders and sync latest orders by pulling to refresh.
- **US6.2:** As an admin, I want to view the details of a specific order (items, user info, total amount).
- **US6.3:** As an admin, I want to update the status of an order (e.g., from Pending to Processing, or to Delivered) so that the user can track the progress.
