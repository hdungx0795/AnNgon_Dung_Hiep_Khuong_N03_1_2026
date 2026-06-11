import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_sizes.dart';
import '../../models/chat_message_model.dart';

class DeliveryChatScreen extends StatefulWidget {
  final String shipperName;

  const DeliveryChatScreen({super.key, required this.shipperName});

  @override
  State<DeliveryChatScreen> createState() => _DeliveryChatScreenState();
}

class _DeliveryChatScreenState extends State<DeliveryChatScreen> {
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      id: const Uuid().v4(),
      text: 'Chào bạn, tôi đang lấy hàng.',
      isMe: false,
      timestamp: DateTime.now(),
    ),
  ];

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _autoReplyTimer;

  final List<String> _quickReplies = [
    'Giao đến đâu rồi bạn?',
    'Để ở cổng giúp mình nhé.',
    'Mình xuống ngay đây.',
    'Cảm ơn bạn nhiều!',
  ];

  @override
  void dispose() {
    _autoReplyTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text, {bool isMe = true}) {
    final messageText = text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: const Uuid().v4(),
          text: messageText,
          isMe: isMe,
          timestamp: DateTime.now(),
        ),
      );
      if (isMe) _controller.clear();
    });

    _scrollToBottom();

    if (isMe) {
      _handleAutoReply(messageText);
    }
  }

  void _handleAutoReply(String userMessage) {
    String reply = 'Vâng ạ, tôi sẽ giao sớm.';
    final lowerMsg = userMessage.toLowerCase();

    if (lowerMsg.contains('đến đâu') || lowerMsg.contains('ở đâu')) {
      reply = 'Tôi đang ở gần đường Phan Xích Long, khoảng 5 phút nữa đến nhé.';
    } else if (lowerMsg.contains('cổng')) {
      reply = 'Dạ vâng, tôi sẽ để ở cổng và chụp hình gửi bạn.';
    } else if (lowerMsg.contains('xuống ngay')) {
      reply = 'Dạ vâng, tôi đang đứng trước sảnh rồi ạ.';
    } else if (lowerMsg.contains('cảm ơn')) {
      reply = 'Không có gì ạ, chúc bạn ngon miệng!';
    }

    _autoReplyTimer?.cancel();
    _autoReplyTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _sendMessage(reply, isMe: false);
      }
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
                controller: _scrollController,
                key: const Key('delivery-chat-message-list'),
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(text: message.text, isMe: message.isMe);
                },
              ),
            ),
            _QuickReplyBar(
              replies: _quickReplies,
              onSelected: (text) => _sendMessage(text),
            ),
            _ChatInput(
              controller: _controller,
              onSend: () => _sendMessage(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickReplyBar extends StatelessWidget {
  const _QuickReplyBar({required this.replies, required this.onSelected});

  final List<String> replies;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        itemCount: replies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: ActionChip(
              label: Text(replies[index]),
              onPressed: () => onSelected(replies[index]),
              padding: EdgeInsets.zero,
              labelStyle: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: colorScheme.primaryContainer.withValues(
                alpha: 0.3,
              ),
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
          );
        },
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
      decoration: BoxDecoration(color: colorScheme.surface),
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
