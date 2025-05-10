import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../res/resources.dart';
import '../../util/common.dart';
import '../../util/constants.dart';
import '../../util/localizations.dart';
import 'custom_text_label.dart';

typedef CustomTextFieldValidator<T> = String? Function(String value);

class CustomTextInput extends StatefulWidget {
  final ValueChanged<String>? onSubmitted;
  final TextInputType keyboardType;
  final String title;
  final TextStyle? titleStyle;
  final int maxLines;
  final TextInputAction? textInputAction;
  final Function? getTextFieldValue;
  final int minLines;
  final bool obscureText;
  final String hintText;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final initData;
  final double? width;
  final double? heightTextInput;
  final double? fontSize;
  final TextEditingController? textController;

  final FontWeight? fontWeight;
  final TextAlign? align;
  final bool enabled;
  final Color colorBgTextField;
  final Color colorBgTextFieldDisable;
  final bool formatNumber;
  final Color colorText;
  final int maxLength;
  final bool formatPercent;
  final bool formatDecimal;
  final Widget? suffixIcon;
  final double? suffixIconMargin;
  final Widget? prefixIcon;
  final bool isPasswordTF;
  final bool isDateTimeTF;
  final bool isDropdownTF;
  final bool isRequired;
  final bool formatCurrency;
  final CustomTextFieldValidator? validator;
  final Function? onTapTextField;
  final VoidCallback? onTapSuffixIcon;
  final bool autoFocus;
  final TextStyle? hintStyle;
  final Function()? onTap;
  final bool enableErrorSuffix;
  final bool clearButton;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final String hintUnderText;
  final FocusNode? focusNode;
  final int? millisecondsDebounce;
  final bool autoCheckValidate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DropdownItem>? dropdownItems;
  final Function(DropdownItem?)? onDropdownChanged;
  final DropdownItem? selectedDropdownItem;

  CustomTextInput({
    Key? key,
    this.getTextFieldValue,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.title = "",
    this.maxLines = 1,
    this.textInputAction,
    this.minLines = 1,
    this.obscureText = false,
    this.hintText = "",
    this.margin,
    this.padding,
    this.initData,
    this.titleStyle,
    this.width,
    this.heightTextInput,
    this.textController,
    this.fontWeight,
    this.align,
    this.enabled = true,
    this.colorText = Colors.black,
    this.maxLength = TextField.noMaxLength,
    this.formatPercent = false,
    this.formatDecimal = false,
    this.suffixIcon,
    this.suffixIconMargin,
    this.prefixIcon,
    this.isPasswordTF = false,
    this.isDateTimeTF = false,
    this.isDropdownTF = false,
    this.isRequired = false,
    this.colorBgTextField = AppColors.white,
    this.colorBgTextFieldDisable = AppColors.disable,
    this.formatCurrency = false,
    this.formatNumber = false,
    this.validator,
    this.onTapTextField,
    this.onTapSuffixIcon,
    this.autoFocus = false,
    this.fontSize,
    this.hintStyle,
    this.onTap,
    this.enableErrorSuffix = true,
    this.clearButton = false,
    this.disabledBorder,
    this.focusedBorder,
    this.enabledBorder,
    this.hintUnderText = "",
    this.focusNode,
    this.millisecondsDebounce,
    this.autoCheckValidate = true,
    this.firstDate,
    this.lastDate,
    this.dropdownItems,
    this.onDropdownChanged,
    this.selectedDropdownItem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextFieldState();
  }
}

// Data class for dropdown items
class DropdownItem {
  final int id;
  final String value;
  final dynamic additionalData;

  DropdownItem({required this.id, required this.value, this.additionalData});
}

class TextFieldState extends State<CustomTextInput> {
  bool _showText = true;
  late List<TextInputFormatter> inputFormatters;
  String errorText = '';
  late TextEditingController textController;
  Timer? _debounce;
  DropdownItem? _selectedItem;

  DateTime? firstDate;
  DateTime? lastDate;

  void setErrorText(String error) {
    setState(() {
      errorText = error;
    });
  }

  void setText(String text, {bool updateGetTextFieldValue = false}) {
    setState(() {
      textController.text = text;
      if (updateGetTextFieldValue == true) {
        _validate();
        widget.getTextFieldValue?.call(text);
      }
    });
  }

  @override
  void initState() {
    firstDate = widget.firstDate;
    lastDate = widget.lastDate;
    _selectedItem = widget.selectedDropdownItem;
    super.initState();
    textController = widget.textController ?? TextEditingController();

    if (widget.initData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isDropdownTF && _selectedItem != null) {
          textController.text = _selectedItem!.value;
        } else {
          textController.text =
          widget.formatCurrency ? Common.formatPrice(widget.initData, showPrefix: false) : widget.initData.toString();
        }
      });
    }

    if (widget.formatNumber || widget.formatCurrency || widget.formatPercent) {
      inputFormatters = [NumericTextFormatter(widget.formatCurrency, widget.formatPercent)];
    } else if (widget.formatDecimal) {
      inputFormatters = [DecimalTextInputFormatter(decimalRange: 5)];
    } else {
      inputFormatters = [];
    }

    if(widget.autoCheckValidate == false){
      widget.focusNode?.addListener(() {
        if (!widget.focusNode!.hasFocus) {
          _validate();
        }
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initData != oldWidget.initData) {
      if (widget.isDropdownTF && widget.selectedDropdownItem != null) {
        textController.text = widget.selectedDropdownItem!.value;
      } else {
        textController.text =
        widget.formatCurrency ? Common.formatPrice(widget.initData, showPrefix: false) : widget.initData.toString();
      }
    }

    if (widget.selectedDropdownItem != oldWidget.selectedDropdownItem) {
      _selectedItem = widget.selectedDropdownItem;
      if (_selectedItem != null) {
        textController.text = _selectedItem!.value;
      }
    }
  }

  void _showDropdownMenu(BuildContext context) {
    if (widget.dropdownItems == null || widget.dropdownItems!.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: CustomTextLabel(
                widget.title.isNotEmpty ? widget.title : widget.hintText,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: widget.dropdownItems!.length,
                itemBuilder: (context, index) {
                  final item = widget.dropdownItems![index];
                  return ListTile(
                    title: CustomTextLabel(item.value),
                    onTap: () {
                      setState(() {
                        _selectedItem = item;
                        textController.text = item.value;
                      });
                      widget.onDropdownChanged?.call(item);
                      widget.getTextFieldValue?.call(item.value);
                      Navigator.pop(context);
                      _validate();
                    },
                    selected: _selectedItem?.id == item.id,
                    selectedTileColor: AppColors.base_color.withOpacity(0.1),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if text input should be disabled
    bool isReadOnly = widget.isDateTimeTF || widget.isDropdownTF;

    return Container(
      width: widget.width ?? double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      child: Wrap(
        children: [
          if (widget.title.isNotEmpty)
            CustomTextLabel.renderBaseTitle(title: widget.title, isRequired: widget.isRequired),
          Container(
            height: widget.heightTextInput,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.enabled ? widget.colorBgTextField : widget.colorBgTextFieldDisable,
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                if (widget.isRequired)
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 3),
                  child: const CustomTextLabel(
                    "*",
                    color: AppColors.colorError,
                  ),
                ),
                TextField(
                  focusNode: widget.focusNode,
                  inputFormatters: inputFormatters,
                  maxLength: widget.maxLength,
                  cursorColor: AppColors.base_color,
                  autofocus: widget.autoFocus,
                  enabled: widget.enabled,
                  textAlign: widget.align ?? TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: widget.onTap,
                  style: TextStyle(
                      color: widget.colorText,
                      fontSize: widget.fontSize ?? 14,
                      fontWeight: widget.fontWeight ?? FontWeight.w400),
                  decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: widget.suffixIconMargin ?? 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (errorText.isNotEmpty && widget.enableErrorSuffix)
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                            if (widget.isPasswordTF == true)
                              IconButton(
                                icon: Icon(!_showText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () {
                                  setState(() {
                                    _showText = !_showText;
                                  });
                                },
                              ),
                            if (widget.isDateTimeTF == true)
                              IconButton(
                                  onPressed: () {
                                    chooseDay(context);
                                  },
                                  icon: Icon(Icons.calendar_today_rounded)),
                            if (widget.isDropdownTF == true)
                              IconButton(
                                onPressed: () {
                                  if (widget.enabled) {
                                    _showDropdownMenu(context);
                                  }
                                },
                                icon: Icon(Icons.arrow_drop_down),
                              ),
                            if (widget.clearButton && textController.text.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  textController.clear();
                                  setState(() {
                                    if (widget.isDropdownTF) {
                                      _selectedItem = null;
                                      widget.onDropdownChanged?.call(null);
                                    }
                                  });
                                  widget.getTextFieldValue?.call("");
                                },
                                child: Container(
                                  // margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffe6e8eb),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      size: 10,
                                    )),
                              ),
                            if (widget.suffixIcon != null)
                              Padding(
                                padding: EdgeInsets.only(left: 0, right: 0),
                                child: widget.suffixIcon,
                              ),
                          ],
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: widget.prefixIcon,
                      ),
                      focusColor: Colors.white,
                      border: InputBorder.none,
                      suffixIconConstraints: BoxConstraints(maxHeight: 35),
                      prefixIconConstraints: BoxConstraints(maxHeight: 35),
                      disabledBorder: widget.disabledBorder ??
                          UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                      focusedBorder: widget.focusedBorder ??
                          UnderlineInputBorder(borderSide: BorderSide(color: AppColors.focusBorder)),
                      enabledBorder: widget.enabledBorder ??
                          UnderlineInputBorder(
                              borderSide: BorderSide(color: errorText == "" ? AppColors.border : AppColors.colorError)),
                      hintStyle: widget.hintStyle ??
                          TextStyle(
                              color: !widget.enabled ? AppColors.black : AppColors.hintTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                      hintText: widget.hintText,
                      isDense: true,
                      contentPadding: widget.padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
                  controller: textController,
                  obscureText: widget.isPasswordTF == true ? (_showText) : widget.obscureText,
                  keyboardType: widget.formatCurrency ? TextInputType.number : widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  onChanged: (String _text) {
                    if(widget.autoCheckValidate) {
                      _validate();
                    }
                    if (widget.clearButton == true) setState(() {});
                    String currentText = _text.trim();
                    if (widget.millisecondsDebounce != null) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(Duration(milliseconds: widget.millisecondsDebounce!), () {
                        widget.getTextFieldValue?.call(currentText);
                      });
                    } else {
                      widget.getTextFieldValue?.call(currentText);
                    }
                  },
                ),
                widget.onTapTextField != null || widget.isDropdownTF || widget.isDateTimeTF
                    ? Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      if (this.widget.enabled) {
                        if (widget.isDropdownTF) {
                          _showDropdownMenu(context);
                        } else if (widget.isDateTimeTF) {
                          chooseDay(context);
                        } else {
                          widget.onTapTextField?.call();
                        }
                      }
                    },
                    child: Container(),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
          errorText.isNotEmpty
              ? ErrorTextWidget(errorText: errorText)
              : widget.hintUnderText.isNotEmpty
              ? Container(
            margin: EdgeInsets.only(top: 6),
            child: Text(
              widget.hintUnderText,
              style: TextStyle(
                  color: !widget.enabled ? AppColors.black : AppColors.hintTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          )
              : Container()
        ],
      ),
    );
  }

  String getText(DateTime dateTime) {
    return Common.datetimeToSting(dateTime);
  }

  bool get isValid => _validate();

  String get value => textController.text.trim();

  DropdownItem? get selectedDropdownItem => _selectedItem;

  bool _validate() {
    if (widget.validator != null) {
      String _text = textController.text.trim();
      String? validate = widget.validator!.call(_text);
      setState(() {
        this.errorText = validate ?? "";
      });
      return this.errorText.isEmpty;
    }
    return true;
  }

  Future chooseDay(BuildContext context) async {
    DateTime initDate = Common.parserDate(value, format: FormatDate.dayMonthYear) ?? DateTime.now();
    DateTime firstDate = this.firstDate ?? DateTime(DateTime.now().year - 50);
    DateTime lastDate = this.lastDate ?? DateTime(DateTime.now().year + 50);
    if (initDate.isBefore(firstDate)) {
      initDate = firstDate;
    }
    if (initDate.isAfter(lastDate)) {
      initDate = lastDate;
    }

    var newDate =
    await showDatePicker(context: context, initialDate: initDate, firstDate: firstDate, lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.base_pink,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.base_pink,
                ),
              ),
            ),
            child: child!,
          );
        }
    );
    if (newDate == null) return;
    textController.text = getText(newDate);
    widget.getTextFieldValue?.call(value);
  }
}

class NumericTextFormatter extends TextInputFormatter {
  final bool isFormatCurrency;
  final bool isFormatPercent;

  NumericTextFormatter(this.isFormatCurrency, this.isFormatPercent);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      if (oldValue.text == '0' && newValue.text == '00') {
        return oldValue;
      }

      if (oldValue.text.length < newValue.text.length) {
        String s = newValue.text.substring(newValue.selection.baseOffset - 1, newValue.selection.baseOffset);
        if (!RegExp("^[0-9]").hasMatch(s)) return oldValue;
      }

      if (isFormatPercent) {
        if ((oldValue.text == "100" && newValue.text.length > 3) ||
            '.'.allMatches(newValue.text).length > 1 ||
            double.parse(newValue.text) > 100 ||
            newValue.text[0] == "." ||
            (newValue.text.length > 1 && newValue.text[0] == "0" && newValue.text[1] != ".") ||
            newValue.text.split(".").length > 1 && newValue.text.split(".")[1].length > 2) {
          return oldValue;
        } else {
          return newValue;
        }
      }

      final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final f = isFormatCurrency ? NumberFormat("#,###") : NumberFormat('#');
      final number = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return oldValue;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (newValue.text.contains(' '))
      return TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
        composing: TextRange.empty,
      );

    if (oldValue.text == '0') {
      truncated = newValue.text.replaceFirst('0', '');
      if (!RegExp("^[0-9]").hasMatch(truncated)) {
        truncated = newValue.text;
      } else {
        newSelection = newValue.selection.copyWith(
          baseOffset: 1,
          extentOffset: 1,
        );
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }

    if (truncated.length > oldValue.text.length && newValue.text.substring(0, 1) == '0' && oldValue.text.length > 1) {
      if (!(newValue.text.length > 2 && newValue.text.substring(0, 2) == '0.')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
    }

    if (decimalRange != null) {
      String value = newValue.text;
      if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}