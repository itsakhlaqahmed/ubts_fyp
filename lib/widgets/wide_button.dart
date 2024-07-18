import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.isLoading,
    required this.onSubmitForm,
    required this.buttonText,
  });

  final String buttonText;
  final bool isLoading;
  final Function onSubmitForm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // isLoading ? null : 
        onSubmitForm();

      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 117, 75, 243),
        ),
        child: Center(
          child: isLoading
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
                      ),
                ),
        ),
      ),
    );
  }
}
