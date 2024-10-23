import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class StoreDetails extends StatelessWidget {
  StoreDetails(
      {Key? key,
      required this.name,
      required this.storeId,
      required this.rating,
      this.image})
      : super(key: key);

  final String name;
  final String storeId;
  String? image;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(normal_100),
        child: Row(children: [
          if (image != null)
            SizedBox(
                height: large_150,
                width: large_150,
                child: Stack(alignment: Alignment.topRight, children: [
                  Positioned.fill(
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(normalRadius),
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: (image != null)
                                  ? Image.network(image ?? "")
                                  : Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/5853/5853761.png")))),
                ])),
          const SizedBox(width: normal_100),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
                StarRating(rating: rating)
              ])),
          // Text(followers.toString()),
          InkWell(
            child: Icon(
              Icons.share,
              size: 20,
            ),
            onTap: () {
              _showSharePopup(context, storeId);
            },
          ),
          SizedBox(
            width: 10,
          ),
          const Icon(ProximityIcons.heart)
        ]));
  }

  final String dynamicUrl =
      "https://www.proximity.com/store/"; // Dynamic URL to be copied

  void copyToClipboard(BuildContext context, String id) {
    Clipboard.setData(ClipboardData(text: dynamicUrl + id));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('URL copied to clipboard')),
    );
  }

  void closeShareWindow(BuildContext context) {
    // Logic to share via email
    Navigator.pop(context);
  }

  void shareWithEmail(BuildContext context) {
    // Logic to share via email
    Navigator.pop(context);
  }

  void shareWithSMS(BuildContext context) {
    // Logic to share via SMS
    Navigator.pop(context);
  }

  void _showSharePopup(BuildContext context, String storeId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallIconButton(
                  onPressed: () {
                    closeShareWindow(context);
                  },
                  icon: const Icon(ProximityIcons.chevron_left)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text('Share Options'),
              )
            ],
          ),
          content: Consumer<ShareService>(builder: (context, shareService, _) {
            if (shareService.shareOption == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.copy),
                    title: Text(
                      'Copy URL',
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () => copyToClipboard(context, storeId),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(
                      'Share with Email',
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      shareService.changeOption(1);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.sms),
                    title: Text(
                      'Share with SMS',
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      shareService.changeOption(2);
                    },
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shareService.shareOption == 1)
                    EditText(
                      controller: () {
                        TextEditingController _controller =
                            TextEditingController();
                        _controller.text = shareService.email ?? "";
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                        return _controller;
                      }(),
                      hintText: 'Email.',
                      borderType: BorderType.top,
                      onChanged: shareService.changeEmail,
                    ),
                  if (shareService.shareOption == 2)
                    EditText(
                      controller: () {
                        TextEditingController _controller =
                            TextEditingController();
                        _controller.text = shareService.phone ?? "";
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                        return _controller;
                      }(),
                      hintText: 'Phone.',
                      borderType: BorderType.top,
                      onChanged: shareService.changePhone,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SecondaryButton(
                          onPressed: () {
                            shareService.changeOption(0);
                          },
                          title: "Back"),
                      PrimaryButton(
                        buttonState: ButtonState.enabled,
                        onPressed: () {
                          if (shareService.shareOption == 1) {
                            shareService.shareStore(storeId, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Error , re-try please')),
                            );
                          }
                        },
                        title: "Send.",
                      ),
                    ],
                  )
                ],
              );
            }
          }),
        );
      },
    );
  }
}
