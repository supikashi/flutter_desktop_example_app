import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GesturesTab extends StatefulWidget {
  const GesturesTab({super.key});

  @override
  State<GesturesTab> createState() => _GesturesTabState();
}

class _GesturesTabState extends State<GesturesTab> {
  bool _isHovering = false;
  bool _isMenuOpen = false;
  bool _isPressed = false;
  String _status = 'Нажми, наведи\nили нажми ⌘+C / Delete';
  TapDownDetails? _tapDownDetails;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _showActionSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        width: 300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      )
    );
  }

  void _showContextMenu(BuildContext context) async {
    final position = _tapDownDetails?.globalPosition ?? Offset.zero;
    _isMenuOpen = true;
    
    await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx, position.dy, position.dx + 1, position.dy + 1,
      ),
      items: [
        const PopupMenuItem(value: 1, child: Row(children: [Icon(Icons.copy, size: 18), SizedBox(width: 8), Text("Скопировать")])),
        const PopupMenuItem(value: 2, child: Row(children: [Icon(Icons.paste, size: 18), SizedBox(width: 8), Text("Вставить")])),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 3, child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text("Удалить", style: TextStyle(color: Colors.red))])),
      ],
    );
    
    _isMenuOpen = false;
    if (mounted && !_isHovering) {
      setState(() => _status = 'Нажми, наведи\nили нажми ⌘+C / Delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyC, meta: true): () => _showActionSnackBar('Копирование (Cmd+C)', Icons.copy),
          const SingleActivator(LogicalKeyboardKey.keyV, meta: true): () => _showActionSnackBar('Вставка (Cmd+V)', Icons.paste),
          const SingleActivator(LogicalKeyboardKey.delete): () => _showActionSnackBar('Delete нажат!', Icons.delete_forever),
          const SingleActivator(LogicalKeyboardKey.backspace): () => _showActionSnackBar('Backspace нажат!', Icons.delete_forever),
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) {
              setState(() {
                _isHovering = false;
                if (!_isMenuOpen) _status = 'Нажми, наведи\nили нажми ⌘+C / Delete';
              });
            },
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
          onSecondaryTapDown: (details) {
             _tapDownDetails = details;
             setState(() => _isPressed = true);
          },
          onSecondaryTapUp: (_) => setState(() => _isPressed = false),
          onSecondaryTapCancel: () => setState(() => _isPressed = false),
          onSecondaryTap: () {
            setState(() {
              _status = 'Правый клик (Контекстное меню)!';
              _isPressed = false;
            });
            _showContextMenu(context);
          },
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () => setState(() => _status = 'Левый клик!'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
            transformAlignment: Alignment.center,
            width: 400,
            height: 250,
            decoration: BoxDecoration(
              color: _isPressed 
                  ? Colors.blue.shade700 
                  : (_isHovering ? Colors.blueAccent : Colors.grey[200]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovering && !_isPressed
                  ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 4))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: _isPressed ? 2 : 4, offset: Offset(0, _isPressed ? 1 : 2))],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Icon(Icons.desktop_windows, size: 48, color: Colors.black54),
                 const SizedBox(height: 16),
                 Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isHovering ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isHovering ? "Курсор внутри" : "Курсор снаружи",
                  style: TextStyle(
                    fontSize: 14,
                    color: _isHovering ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    ),
    );
  }
}