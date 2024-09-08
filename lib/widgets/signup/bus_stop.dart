import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/models/bus_stop.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

class BusStopPanel extends StatefulWidget {
  const BusStopPanel({
    super.key,
    required this.busStops,
    required this.onSelectBusStop,
  });

  final List<BusStop> busStops;
  final Future<void> Function(String stop) onSelectBusStop;
  @override
  State<BusStopPanel> createState() => _BusStopPanelState();
}

class _BusStopPanelState extends State<BusStopPanel> {
  BusStop? _selectedStop;
  bool _error = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
          duration: Duration(milliseconds: 200),
          begin: Offset(3, 0),
          curve: Curves.easeOutCubic,
        )
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            const Text(
              'Select Your Bus Route',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            _error
                ? const Center(
                    child: Text(
                      'Kindly select a bus route',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.busStops.length,
              itemBuilder: (context, index) {
                bool isSelected = false;
                if (_selectedStop != null) {
                  isSelected = widget.busStops.indexOf(_selectedStop!) == index;
                }

                return Container(
                  key: ValueKey(widget.busStops[index]),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStop = widget.busStops[index];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? ColorTheme.primaryTint1
                              : Colors.black,
                        ),
                        color: isSelected
                            ? ColorTheme.colorWithOpacity(
                                ColorTheme.primaryTint1, .2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stop ${index + 1}.',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.subdirectory_arrow_right),
                              const SizedBox(
                                width: 6,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Coming from',
                                    style: TextStyle(
                                      fontSize: 10,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.busStops[index].from,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.pin_drop_outlined),
                              const SizedBox(
                                width: 6,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Stop',
                                    style: TextStyle(
                                      fontSize: 10,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.busStops[index].to,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorTheme.primaryShade1
                                      : ColorTheme.primaryWithOpacity(.95),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedStop = widget.busStops[index];
                                      });
                                    },
                                    child: Text(
                                      isSelected ? 'Selected' : 'Select',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            WideButton(
              isLoading: _isLoading,
              onSubmitForm: () async {
                if (_selectedStop != null) {
                  setState(() {
                    _error = false;
                    _isLoading = true;
                  });

                  await widget.onSelectBusStop(_selectedStop!.toString());

                  setState(() {
                    _isLoading = false;
                  });
                } else {
                  setState(() {
                    _error = true;
                  });
                }
              },
              buttonText: 'Signup',
            ),
            const SizedBox(
              height: 72,
            )
          ],
        ),
      ),
    );
  }
}
