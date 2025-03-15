import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Builder for the selected option widget in [FlutterSelect].
typedef FlutterSelectedOptionBuilder<T> = Widget Function(BuildContext context, T value);

/// Controls the selection state of a [FlutterSelect] widget.
///
/// It extends [ValueNotifier] to provide reactive updates when the selected
/// values change.
class FlutterSelectController<T> extends ValueNotifier<List<T>> {
  FlutterSelectController({List<T>? initialValue}) : super(initialValue ?? []);
}

/// Defines the different variants of the [FlutterSelect] widget.
enum FlutterSelectVariant { primary, search, multiple, multipleWithSearch }

/// A customizable select dropdown widget with various variants and options.
///
/// It supports single and multiple selection, search functionality, and
/// extensive customization through various properties.
class FlutterSelect<T> extends StatefulWidget {
  /// Creates a [FlutterSelect] with the primary variant.
  const FlutterSelect({
    super.key,
    required this.selectedOptionBuilder,
    this.options,
    this.optionsBuilder,
    this.enabled = true,
    this.placeholder,
    this.initialValue,
    this.initialValues = const [],
    this.onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.scrollController,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
  }) : variant = FlutterSelectVariant.primary,
       onSearchChanged = null,
       searchPlaceholder = null,
       searchInputLeading = null,
       onMultipleChanged = null,
       searchPadding = null,
       selectedOptionsBuilder = null,
       search = null,
       clearSearchOnClose = false,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// Creates a [FlutterSelect] with the search variant.
  const FlutterSelect.withSearch({
    super.key,
    this.options,
    this.optionsBuilder,
    required this.selectedOptionBuilder,
    required ValueChanged<String> this.onSearchChanged,
    this.onChanged,
    this.searchPlaceholder,
    this.searchInputLeading,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose = false,
    this.enabled = true,
    this.placeholder,
    this.initialValue,
    this.initialValues = const [],
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.scrollController,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
  }) : variant = FlutterSelectVariant.search,
       selectedOptionsBuilder = null,
       onMultipleChanged = null,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// Creates a [FlutterSelect] with the multiple select variant.
  const FlutterSelect.multiple({
    super.key,
    this.options,
    this.optionsBuilder,
    required this.selectedOptionsBuilder,
    this.enabled = true,
    this.placeholder,
    this.initialValues = const [],
    ValueChanged<List<T>>? onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.scrollController,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
  }) : variant = FlutterSelectVariant.multiple,
       onSearchChanged = null,
       initialValue = null,
       selectedOptionBuilder = null,
       searchPlaceholder = null,
       searchInputLeading = null,
       searchPadding = null,
       search = null,
       clearSearchOnClose = false,
       onChanged = null,
       onMultipleChanged = onChanged,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// Creates a [FlutterSelect] with the multiple select and search variant.
  const FlutterSelect.multipleWithSearch({
    super.key,
    this.options,
    this.optionsBuilder,
    required ValueChanged<String> this.onSearchChanged,
    required this.selectedOptionsBuilder,
    ValueChanged<List<T>>? onChanged,
    this.searchPlaceholder,
    this.searchInputLeading,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose = false,
    this.enabled = true,
    this.placeholder,
    this.initialValues = const [],
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.scrollController,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
  }) : variant = FlutterSelectVariant.multipleWithSearch,
       selectedOptionBuilder = null,
       onChanged = null,
       onMultipleChanged = onChanged,
       initialValue = null,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// The controller of the [FlutterSelect].
  final FlutterSelectController<T>? controller;

  /// The callback that is called when the value of the [FlutterSelect] changes.
  ///
  /// This is used for single selection [FlutterSelect] variants.
  final ValueChanged<T?>? onChanged;

  /// The callback that is called when the values of the [FlutterSelect] changes.
  /// Called only when the variant is [FlutterSelect.multiple].
  final ValueChanged<List<T>>? onMultipleChanged;

  /// Whether the [FlutterSelect] allows deselection, defaults to
  /// `false`.
  final bool allowDeselection;

  /// Whether the [FlutterSelect] is enabled.
  ///
  /// When disabled, the select cannot be interacted with and visually appears
  /// disabled. Defaults to `true`.
  final bool enabled;

  /// The initially selected value for single select [FlutterSelect] variants.
  ///
  /// Defaults to `null`.
  final T? initialValue;

  /// The initial values of the [FlutterSelect], defaults to `[]`.
  final List<T> initialValues;

  /// The widget to display as a placeholder when no option is selected.
  ///
  /// Typically a [Text] widget prompting the user to make a selection.
  final Widget? placeholder;

  /// Builder function for rendering the currently selected option in single
  /// select [FlutterSelect] variants.
  ///
  /// This function is called with the current [BuildContext] and the selected
  /// value of type `T`.
  final FlutterSelectedOptionBuilder<T>? selectedOptionBuilder;

  /// Builder function for rendering the currently selected options in multiple
  /// select [FlutterSelect] variants.
  ///
  /// This function is called with the current [BuildContext] and a list of
  /// selected values of type `T`.
  final FlutterSelectedOptionBuilder<List<T>>? selectedOptionsBuilder;

  /// An iterable of widgets representing the selectable options.
  ///
  /// Use this for a small, static set of options. For larger or dynamic lists,
  /// consider using [optionsBuilder] for better performance.
  ///
  /// Each widget in this iterable should typically be a [FlutterOption] widget.
  final Iterable<Widget>? options;

  /// A builder function for creating options widgets on demand.
  ///
  /// This is efficient for large or dynamically generated lists of options, as
  /// it only builds options that are currently visible.
  ///
  /// The builder is called with the [BuildContext] and the index of the option
  /// to build. It should return a widget, typically a [FlutterOption].
  final Widget? Function(BuildContext, int)? optionsBuilder;

  /// The focus node to control the focus state of the [FlutterSelect].
  ///
  /// If null, a default [FocusNode] will be created internally.
  final FocusNode? focusNode;

  /// Whether to close the select popover when tapping outside of it.
  ///
  /// Defaults to `true`.
  final bool closeOnTapOutside;

  /// The minimum width of the select input and popover.
  final double? minWidth;

  /// The maximum width of the select input and popover.
  final double? maxWidth;

  /// The maximum height of the select popover.
  final double? maxHeight;

  /// The visual decoration of the select input.
  final InputDecoration? decoration;

  /// The widget to display at the end of the select input, typically an icon.
  ///
  /// Defaults to a chevron-down icon.
  final Widget? trailing;

  /// The padding around the content of the select input.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`.
  final EdgeInsets? padding;

  /// The padding around the options within the popover.
  ///
  /// Defaults to `EdgeInsets.all(4)`.
  final EdgeInsets? optionsPadding;

  /// The scroll controller for the options list in the popover.
  ///
  /// If null, a default [ScrollController] will be created internally.
  final ScrollController? scrollController;

  /// The variant of the [FlutterSelect] widget, determining its behavior and
  /// appearance.
  ///
  /// See [FlutterSelectVariant] for available variants.
  /// Defaults to [FlutterSelectVariant.primary] for the default constructor.
  final FlutterSelectVariant variant;

  /// Callback function invoked when the search query changes in search-enabled
  /// [FlutterSelect] variants.
  ///
  /// Provides the current search string as an argument.
  final ValueChanged<String>? onSearchChanged;

  /// Widget to display as a placeholder in the search input field when no query is
  /// entered.
  final Widget? searchPlaceholder;

  /// Widget to display at the leading edge of the search input field.
  ///
  /// Typically an icon, like a search icon.
  final Widget? searchInputLeading;

  /// Padding around the search input field.
  ///
  /// Defaults to `EdgeInsets.all(12)`.
  final EdgeInsets? searchPadding;

  /// A completely customizable search input widget.
  ///
  /// If provided, this widget will be used instead of the default [TextField]
  /// for search functionality.
  final Widget? search;

  /// Whether to clear the search input when the popover is closed.
  ///
  /// Defaults to `true`.
  final bool? clearSearchOnClose;

  /// Widget to display at the top of the popover, above the options list.
  ///
  /// Useful for titles or additional information.
  final Widget? header;

  /// Widget to display at the bottom of the popover, below the options list.
  ///
  /// Useful for actions or additional information.
  final Widget? footer;

  /// Whether to automatically close the popover when an option is selected.
  ///
  /// Defaults to `true`.
  final bool closeOnSelect;

  /// The number of items to display when using [optionsBuilder].
  ///
  /// Required when using [optionsBuilder] to determine the scrollable extent.
  final int? itemCount;

  /// Whether the options list should shrink-wrap its content.
  ///
  /// Defaults to `false`. Set to `true` for smaller lists to reduce popover
  /// size.
  final bool? shrinkWrap;

  @override
  FlutterSelectState<T> createState() => FlutterSelectState<T>();
}

class FlutterSelectState<T> extends State<FlutterSelect<T>> {
  FocusNode? _internalFocusNode;
  FlutterSelectController<T>? _controller;
  ScrollController? _scrollController;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  TextEditingController? _searchController;

  FlutterSelectController<T> get controller => widget.controller ?? _controller!;
  FocusNode get focusNode => widget.focusNode ?? _internalFocusNode!;
  ScrollController get scrollController => widget.scrollController ?? _scrollController!;

  bool get isSearchable =>
      widget.variant == FlutterSelectVariant.search ||
      widget.variant == FlutterSelectVariant.multipleWithSearch;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = FlutterSelectController<T>(
        initialValue: [
          if (widget.initialValue is T) widget.initialValue as T,
          ...widget.initialValues,
        ],
      );
    }

    if (widget.scrollController == null) {
      _scrollController = ScrollController();
    }

    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }

    if (isSearchable) {
      _searchController = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(covariant FlutterSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue is T) {
        controller.value
          ..clear()
          ..add(widget.initialValue as T);
      }
    }
    if (widget.initialValues != oldWidget.initialValues) {
      controller.value
        ..clear()
        ..addAll(widget.initialValues);
    }
  }

  @override
  void dispose() {
    _hideDropdown();
    _internalFocusNode?.dispose();
    _scrollController?.dispose();
    _searchController?.dispose();
    // Don't dispose the controller if it was provided externally
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(builder: (context) => _buildDropdownOverlay(size, offset));

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _hideDropdown() {
    if (isSearchable && widget.clearSearchOnClose == true) {
      _searchController?.clear();
      widget.onSearchChanged?.call('');
    }

    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _isOpen = false;
    });
  }

  Widget _buildDropdownOverlay(Size size, Offset offset) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - size.height;
    final effectiveMaxHeight = widget.maxHeight ?? 300.0;
    final showAbove = spaceBelow < effectiveMaxHeight && offset.dy > effectiveMaxHeight;

    final width = widget.minWidth != null ? max(size.width, widget.minWidth!) : size.width;
    final maxWidth = widget.maxWidth ?? double.infinity;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.closeOnTapOutside ? _hideDropdown : null,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              width: min(width, maxWidth),
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, showAbove ? -effectiveMaxHeight : size.height),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).cardColor,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: effectiveMaxHeight,
                      minWidth: widget.minWidth ?? 0,
                      maxWidth: maxWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.header != null) widget.header!,
                        if (isSearchable) _buildSearchField(),
                        Flexible(child: _buildOptionsList()),
                        if (widget.footer != null) widget.footer!,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return widget.search ??
        Padding(
          padding: widget.searchPadding ?? const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              hintText:
                  widget.searchPlaceholder is Text
                      ? (widget.searchPlaceholder as Text).data
                      : 'Search...',
              prefixIcon: widget.searchInputLeading,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: widget.onSearchChanged,
          ),
        );
  }

  Widget _buildOptionsList() {
    final effectiveOptionsPadding = widget.optionsPadding ?? const EdgeInsets.all(4);
    final state = this;

    if (widget.options != null) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: effectiveOptionsPadding,
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children:
                  widget.options!.map((option) {
                    // Wrap each option with a FlutterOptionProvider
                    if (option is FlutterOption<T>) {
                      return FlutterOptionProvider<T>(state: state, child: option);
                    }
                    return option;
                  }).toList(),
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: effectiveOptionsPadding,
        controller: scrollController,
        itemCount: widget.itemCount,
        shrinkWrap: widget.shrinkWrap ?? false,
        itemBuilder: (context, index) {
          return widget.optionsBuilder?.call(context, index);
        },
      );
    }
  }

  void select(T value) {
    final isMultiSelection =
        widget.variant == FlutterSelectVariant.multiple ||
        widget.variant == FlutterSelectVariant.multipleWithSearch;

    final prevList = controller.value.toList(growable: false);
    if (widget.closeOnSelect) _hideDropdown();

    setState(() {
      if (!isMultiSelection) controller.value.clear();
      if (widget.allowDeselection && prevList.contains(value)) {
        controller.value.remove(value);
      } else {
        controller.value.add(value);
      }
    });

    final newList = controller.value.toList(growable: false);
    final changed = !ListEquality<T>().equals(prevList, newList);

    if (changed) {
      if (isMultiSelection) {
        widget.onMultipleChanged?.call(controller.value.toList());
      } else {
        widget.onChanged?.call(controller.value.firstOrNull);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMultiSelect = widget.selectedOptionsBuilder != null;

    // Determine which widget to show as the selected value
    final Widget effectiveText;
    if (controller.value.isNotEmpty) {
      if (isMultiSelect) {
        effectiveText = widget.selectedOptionsBuilder!(context, controller.value.toList());
      } else {
        effectiveText = widget.selectedOptionBuilder!(context, controller.value.first);
      }
    } else {
      assert(widget.placeholder != null, 'placeholder must not be null when value is null');
      effectiveText = widget.placeholder!;
    }

    // Default trailing icon
    final effectiveTrailing =
        widget.trailing ?? Icon(Icons.arrow_drop_down, color: theme.hintColor);

    // Default padding
    final effectivePadding =
        widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    return CompositedTransformTarget(
      link: _layerLink,
      child: AbsorbPointer(
        absorbing: !widget.enabled,
        child: GestureDetector(
          onTap: widget.enabled ? _toggleDropdown : null,
          child: Focus(
            focusNode: focusNode,
            child: Container(
              constraints: BoxConstraints(
                minWidth: widget.minWidth ?? 0,
                maxWidth: widget.maxWidth ?? double.infinity,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: _isOpen ? theme.primaryColor : theme.dividerColor),
                borderRadius: BorderRadius.circular(4),
                color: widget.enabled ? theme.cardColor : theme.disabledColor.withOpacity(0.1),
              ),
              child: InputDecorator(
                decoration:
                    widget.decoration ??
                    InputDecoration(
                      border: InputBorder.none,
                      contentPadding: effectivePadding,
                      isDense: true,
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color:
                              controller.value.isEmpty
                                  ? theme.hintColor
                                  : theme.textTheme.bodyMedium!.color,
                        ),
                        child: effectiveText,
                      ),
                    ),
                    effectiveTrailing,
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

class FlutterOptionProvider<T> extends InheritedWidget {
  final FlutterSelectState<T> state;

  const FlutterOptionProvider({super.key, required this.state, required super.child});

  static FlutterSelectState<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlutterOptionProvider<T>>()?.state;
  }

  @override
  bool updateShouldNotify(FlutterOptionProvider<T> oldWidget) {
    return state != oldWidget.state;
  }
}

class FlutterOption<T> extends StatefulWidget {
  const FlutterOption({
    super.key,
    required this.value,
    required this.child,
    this.hoveredBackgroundColor,
    this.padding,
    this.selectedIcon,
  });

  /// The value of the [FlutterOption], it must be unique among the options.
  final T value;

  /// The child widget.
  final Widget child;

  /// The background color of the [FlutterOption] when hovered.
  final Color? hoveredBackgroundColor;

  /// The padding of the [FlutterOption], defaults to
  /// `EdgeInsets.symmetric(horizontal: 8, vertical: 6)`
  final EdgeInsets? padding;

  /// The icon of the [FlutterOption] when selected.
  final Widget? selectedIcon;

  @override
  State<FlutterOption<T>> createState() => _FlutterOptionState<T>();
}

class _FlutterOptionState<T> extends State<FlutterOption<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectState = FlutterOptionProvider.of<T>(context);
    if (selectState == null) {
      throw FlutterError('FlutterOption must be used within a FlutterSelect');
    }

    final selected = selectState.controller.value.contains(widget.value);
    final effectivePadding =
        widget.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    final effectiveHoveredBackgroundColor = widget.hoveredBackgroundColor ?? theme.hoverColor;

    final effectiveSelectedIcon =
        widget.selectedIcon ??
        (selected
            ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.check, size: 16, color: theme.primaryColor),
            )
            : const SizedBox.shrink());

    return InkWell(
      onTap: () => selectState.select(widget.value),
      onHover: (isHovered) {
        setState(() {
          _isHovered = isHovered;
        });
      },
      child: Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: _isHovered ? effectiveHoveredBackgroundColor : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            effectiveSelectedIcon,
            Expanded(
              child: DefaultTextStyle(style: theme.textTheme.bodyMedium!, child: widget.child),
            ),
          ],
        ),
      ),
    );
  }
}
