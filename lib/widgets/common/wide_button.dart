import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    this.isLoading,
    required this.onSubmitForm,
    required this.buttonText,
    this.isDisabled,
  });

  final String buttonText;
  final bool? isLoading;
  final Function onSubmitForm;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            color: isDisabled ?? false
                ? const Color.fromARGB(110, 253, 130, 59)
                : const Color(0xFFFD813B),
            gradient: isDisabled ?? false
                ? null
                : const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 118, 38),
                      Color.fromARGB(255, 253, 129, 59),
                    ],
                  )),
        child: Center(
          child: isLoading ?? false
              ? const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  buttonText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
        ),
      ),
    );
  }
}
