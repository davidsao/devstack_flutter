import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Base64ImagePage
    extends BaseView<Base64ImageController, Base64ImageState> {
  const Base64ImagePage({super.key, super.viewTag});

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Base64 Image Encoder and Decoder",
              style: AppTextStyles.b1.bold,
            ),
            kGapMedium,

            // --- CONFIGURATION CARD ---
            _buildCard(
              context,
              title: "Configuration",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select which operation you want to perform"),
                  Obx(() => ToggleButtons(
                        isSelected: [
                          state.isEncode.value,
                          !state.isEncode.value
                        ],
                        onPressed: (index) =>
                            controller.setOperation(index == 0),
                        borderRadius: BorderRadius.circular(8),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Text("Encode"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Text("Decode"),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            kGapMedium,

            // --- MAIN DYNAMIC WORKSPACE ---
            Obx(() => state.isEncode.value
                ? _buildEncoderWorkspace(context)
                : _buildDecoderWorkspace(context)),
          ],
        ),
      ),
    );
  }

  // --- WORKSPACE: Image -> Base64 ---
  Widget _buildEncoderWorkspace(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          title: "Source Image",
          child: Column(
            children: [
              InkWell(
                onTap: controller.pickImage,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).dividerColor,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).dividerColor.withOpacity(0.03),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_rounded,
                          size: 36, color: Theme.of(context).disabledColor),
                      kGapSmall,
                      Text("Click to browse or drop an image file here",
                          style: AppTextStyles.b3),
                    ],
                  ),
                ),
              ),
              if (state.imageBytes.value != null) ...[
                kGapMedium,
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(state.imageBytes.value!,
                        fit: BoxFit.contain),
                  ),
                ),
              ]
            ],
          ),
        ),
        kGapMedium,
        _buildCard(
          context,
          title: "Base64 Output String",
          actions: [
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 18),
              onPressed: () {
                if (state.base64Output.value.isNotEmpty) {
                  Clipboard.setData(
                      ClipboardData(text: state.base64Output.value));
                  Get.snackbar("Copied", "Base64 data assigned to clipboard!");
                }
              },
            )
          ],
          child: TextField(
            controller: TextEditingController(text: state.base64Output.value),
            maxLines: 6,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  "Your encoded output string will appear here automatically...",
            ),
            style: AppTextStyles.monoStyle().copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }

  // --- WORKSPACE: Base64 -> Image ---
  Widget _buildDecoderWorkspace(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          title: "Base64 Input String",
          child: TextField(
            maxLines: 6,
            onChanged: controller.decodeBase64,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Paste your raw Base64 data or Data-URI block here...",
            ),
            style: AppTextStyles.monoStyle().copyWith(fontSize: 13),
          ),
        ),
        kGapMedium,
        _buildCard(
          context,
          title: "Image Render Preview",
          child: Container(
            width: double.infinity,
            height: 260,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).dividerColor.withOpacity(0.02),
            ),
            child: state.imageBytes.value != null
                ? Image.memory(
                    state.imageBytes.value!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      "Failed to compile image structure. Check for string truncations.",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                : Text(
                    "A live preview will generate here once valid data is pasted.",
                    style: AppTextStyles.b3
                        .copyWith(color: Theme.of(context).disabledColor),
                  ),
          ),
        ),
      ],
    );
  }

  // --- BASE CARD WRAPPER COMPONENT ---
  Widget _buildCard(BuildContext context,
      {required String title, required Widget child, List<Widget>? actions}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.b2.bold),
              if (actions != null) Row(children: actions),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }
}
