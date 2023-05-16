import 'package:bhashantram/app/common/consts/consts.dart';
import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({Key? key, this.languageList, this.customWidget, this.onTapSelect, required this.selectButtonColor}) : super(key: key);

  final List<String>? languageList;
  final Widget? customWidget;
  final void Function()? onTapSelect;
  final Color selectButtonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConsts.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Center(
              child: Text(
            "Select Language",
            style: TextStyle(fontSize: 16, color: ColorConsts.blueColor),
          )),
          customWidget ??
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.2,
                child: ListView.builder(
                  padding: const EdgeInsets.all(40),
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          languageList?[index] ?? '',
                          style: const TextStyle(fontSize: 12, color: ColorConsts.blueColor),
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: ColorConsts.blueColor)
                      ],
                    );
                  },
                  itemCount: languageList?.length ?? 0,
                ),
              ),
          GestureDetector(
            onTap: onTapSelect,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectButtonColor,
                ),
                height: 40,
                child: const Center(
                  child: Text(
                    "Select",
                    style: TextStyle(fontSize: 20, color: ColorConsts.whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
