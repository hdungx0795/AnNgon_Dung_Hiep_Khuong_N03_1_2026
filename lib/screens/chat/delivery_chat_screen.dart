import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class DeliveryChatScreen extends StatefulWidget {
  final String shipperName;

  const DeliveryChatScreen({super.key, required this.shipperName});

  @override
  State<DeliveryChatScreen> createState() => _DeliveryChatScreenState();
}

class _DeliveryChatScreenState extends State<DeliveryChatScreen> {
  final List<String> _messages = ['Chào bạn, tôi đang lấy hàng.'];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(message);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.delivery_dining,
                size: AppSizes.iconSm,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.shipperName,
                    key: const Key('delivery-chat-shipper-name'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Tài xế giao hàng',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                key: const Key('delivery-chat-message-list'),
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _MessageBubble(
                    text: _messages[index],
                    isMe: index % 2 == 1,
                  );
                },
              ),
            ),
            _ChatInput(controller: _controller, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        key: Key(
          isMe ? 'delivery-chat-message-me' : 'delivery-chat-message-shipper',
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSizes.radiusMd),
            topRight: const Radius.circular(AppSizes.radiusMd),
            bottomLeft: Radius.circular(isMe ? AppSizes.radiusMd : AppSizes.xs),
            bottomRight: Radius.circular(
              isMe ? AppSizes.xs : AppSizes.radiusMd,
            ),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isMe ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.sm,
          AppSizes.md,
          AppSizes.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('delivery-chat-input'),
                controller: controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            IconButton.filled(
              key: const Key('delivery-chat-send-button'),
              tooltip: 'Gửi tin nhắn',
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
