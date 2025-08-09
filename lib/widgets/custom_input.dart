import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType kyboardType;
  final bool isPassword;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon; // 修正: 將 suffixIcon 變數設為可空
  final double? height; // 修正: 將 height 變數設為可空
  final bool enable;
  final TextStyle hintStyle;
  final String? Function(String?)? validator; // 修正: 使用更精確的類型
  final bool readOnly;
  final List<String> suggestons;

  const CustomInput({
    super.key, // 修正: 使用 super.key 的現代寫法
    required this.icon, // 修正: 使用 required 關鍵字
    required this.hintText, // 修正: 使用 required 關鍵字
    required this.textEditingController, // 修正: 使用 required 關鍵字
    this.readOnly = false,
    this.kyboardType = TextInputType.text,
    this.isPassword = false,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.height,
    this.enable = true,
    this.hintStyle = const TextStyle(color: Color(0xFFA3BAFC)),
    this.validator,
    this.suggestons = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEEF4FC),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: RawAutocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          } else {
            List<String> matches = <String>[];
            matches.addAll(suggestons);

            matches.retainWhere((s) {
              return s.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
            return matches;
          }
        },
        onSelected: (String selection) {
          print('You just selected $selection');
          textEditingController.text = selection;
        },
        fieldViewBuilder:
            (
              BuildContext context,
              TextEditingController editingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextFormField(
                validator: validator,
                readOnly: readOnly,
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: textCapitalization,
                controller: editingController,
                autocorrect: false,
                keyboardType: kyboardType,
                obscureText: isPassword,
                focusNode: focusNode,
                style: TextStyle(color: Theme.of(context).primaryColor),
                onChanged: (value) {
                  textEditingController.text = value;
                },
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: hintStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  filled: !enable,
                ),
              );
            },
        optionsViewBuilder:
            (
              BuildContext context,
              void Function(String) onSelected,
              Iterable<String> options,
            ) {
              return Material(
                child: SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((opt) {
                        return InkWell(
                          onTap: () {
                            onSelected(opt);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 60),
                            child: Card(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: Text(opt),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
      ),
    );
  }
}
