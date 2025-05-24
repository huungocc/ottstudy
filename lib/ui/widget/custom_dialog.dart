import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../res/resources.dart';
import 'widget.dart';

class CustomDialog extends StatelessWidget {
  final Function? onSubmit;
  final Function? onClose;
  final String titleSubmit;
  //final Widget? image;
  final dynamic content;
  final String? buttonText;
  final bool? hasCloseButton;

  const CustomDialog({
    Key? key,
    this.onSubmit,
    this.onClose,
    this.titleSubmit = "Ok",
    //this.image,
    this.content,
    this.buttonText,
    this.hasCloseButton = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Wrap(children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, hasCloseButton == true ? 0 : 20, 20, 20),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    //Assets.images.imgSendGray.image(scale: 3.5),
                    if (hasCloseButton == true)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.close_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onClose?.call();
                        }
                      ),
                    ),
                    if (content is String)
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: CustomTextLabel(
                        content,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (content is Widget) content,
                    const SizedBox(height: 20,),
                    BaseButton(
                      title: titleSubmit,
                      onTap: () {
                        //Navigator.of(context).pop();
                        onSubmit?.call();
                      },
                    )
                  ],
                ),
              ),
            ])
          ],
        ));
  }
}
