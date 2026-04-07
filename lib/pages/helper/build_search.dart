import 'package:flutter/material.dart';
import 'package:sakuku_desktop/utils/hover_wrapper.dart';

class GlobalSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final VoidCallback onFilter;
  final Function(String) onChanged;

  const GlobalSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.onFilter,
  });

  @override
  State<GlobalSearchField> createState() => _GlobalSearchFieldState();
}

class _GlobalSearchFieldState extends State<GlobalSearchField> {
  late VoidCallback _focusListener;
  late VoidCallback _textListener;
  @override
  void initState() {
    super.initState();

    _focusListener = () => setState(() {});
    _textListener = () => setState(() {});

    widget.focusNode.addListener(_focusListener);
    widget.controller.addListener(_textListener);

    widget.focusNode.addListener(() {
      setState(() {}); // 🔥 trigger rebuild pas focus berubah
    });

    widget.controller.addListener(() {
      setState(() {}); // biar tombol X muncul/hilang
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    final onFilter = widget.onFilter;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isFocused ? const Color(0xFF2F89FF) : Colors.grey.shade300,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onChanged: (value) => widget.onChanged(value.toLowerCase()),
              decoration: const InputDecoration(
                hintText: "Search product...",
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.controller.clear();
                widget.onChanged("");
              },
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
            ),
          HoverWrapper(
            scale: 1.3,
            child: GestureDetector(
              onTap: onFilter,
              child: Icon(Icons.tune, size: 20, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
