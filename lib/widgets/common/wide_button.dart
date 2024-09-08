import 'package:flutter/material.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    this.isLoading,
    required this.onSubmitForm,
    required this.buttonText,
    this.isDisabled,
    this.color,
  });

  final String buttonText;
  final bool? isLoading;
  final Function onSubmitForm;
  final bool? isDisabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ?? false
          ? null
          : () {
              isLoading ?? false ? null : onSubmitForm();
            },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDisabled == true
              ? ColorTheme.colorWithOpacity(
                  color ?? ColorTheme.primary,
                  .6,
                )
              : null,
          gradient: isDisabled == true
              ? null
              : LinearGradient(
                  colors: [
                    color ?? ColorTheme.primaryShade1,
                    color?.withOpacity(.8) ?? ColorTheme.primary,
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: isLoading ?? false
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: ColorTheme.onPrimaryText,
                  ),
                )
              : Text(
                  buttonText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ColorTheme.onPrimaryText,
                        fontSize: 18,
                      ),
                ),
        ),
      ),
    );
  }
}
