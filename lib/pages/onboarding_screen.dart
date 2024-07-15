import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.data,
    required this.activePageIndex,
    required this.totalScreens,
    required this.onClickNext,
    required this.onSkip,
  });

  final Map<String, String> data;
  final int activePageIndex;
  final int totalScreens;
  final Function() onClickNext;
  final Function() onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              SizedBox(
                height: 400,
                child: Image.asset(
                  data['image']!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Text(
                data['title']!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                data['description']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        pageIndicator(
                          activePageIndex,
                          totalScreens,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: onClickNext,
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.blue,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageIndicator(int index, int len) {
    return Row(
      children: [
        for (var i = 0; i < len; i++)
          Container(
            height: 8,
            margin: const EdgeInsets.only(left: 2),
            width: i == index ? 24 : 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: i == index ? Colors.indigo : Colors.blue,
            ),
          ),
      ],
    );
  }
}
