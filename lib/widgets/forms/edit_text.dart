
  @override
  Widget build(BuildContext context) {
    final Container _editTextContainer = Container(
        padding: (() {
          switch (widget.borderType) {
            case BorderType.single:
              return const EdgeInsets.all(tiny_50);
            case BorderType.top:
              return const EdgeInsets.all(tiny_50).copyWith(bottom: 0);
            case BorderType.topLeft:
              return const EdgeInsets.all(tiny_50)
                  .copyWith(right: 0, bottom: 0);
            case BorderType.topRight:
              return const EdgeInsets.all(tiny_50).copyWith(left: 0, bottom: 0);
            case BorderType.middle:
              return const EdgeInsets.symmetric(horizontal: tiny_50);
            case BorderType.bottom:
              return const EdgeInsets.all(tiny_50).copyWith(top: 0);
            case BorderType.singleLeft:
              return const EdgeInsets.all(tiny_50).copyWith(right: 0);
          }
        }()),
        decoration: BoxDecoration(
          color: (() {
            if (widget.errorText != null) {
              return Theme.of(context).errorColor;
            } else {
              return (_borderColor ?? Theme.of(context).dividerColor);
            }
          }()),
          borderRadius: (() {
            switch (widget.borderType) {
              case BorderType.single:
                return const BorderRadius.all(smallRadius);
              case BorderType.top:
                return const BorderRadius.vertical(top: smallRadius);
              case BorderType.topLeft:
                return const BorderRadius.only(topLeft: smallRadius);
              case BorderType.topRight:
                return const BorderRadius.only(topRight: smallRadius);
              case BorderType.middle:
                return null;
              case BorderType.bottom:
                return const BorderRadius.vertical(bottom: smallRadius);
              case BorderType.singleLeft:
                return const BorderRadius.horizontal(left: smallRadius);
            }
          }()),
        ),
        child: Container(
            height: (widget.maxLines == 1)
                ? normal_300
                : normal_200 * widget.maxLines!,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? Theme.of(context).cardColor
                  : Theme.of(context).backgroundColor,
              borderRadius: (() {
                switch (widget.borderType) {
                  case BorderType.single:
                    return const BorderRadius.all(innerBorderRadius);
                  case BorderType.top:
                    return const BorderRadius.vertical(top: innerBorderRadius);
                  case BorderType.topLeft:
                    return const BorderRadius.only(topLeft: innerBorderRadius);
                  case BorderType.topRight:
                    return const BorderRadius.only(topRight: innerBorderRadius);
                  case BorderType.middle:
                    return null;
                  case BorderType.bottom:
                    return const BorderRadius.vertical(
                        bottom: innerBorderRadius);
                  case BorderType.singleLeft:
                    return const BorderRadius.horizontal(
                        left: innerBorderRadius);
                }
              }()),
            ),
            child: TextFormField(
              focusNode: _focus,
              cursorColor: (widget.errorText != null)
                  ? Theme.of(context).errorColor
                  : null,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              obscureText: widget.obscureText,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.w600),
              enabled: widget.enabled,
              initialValue: widget.saved,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                  labelText: widget.hintText,
                  hintText: widget.hintText,
                  prefixIcon: (widget.prefixIcon != null)
                      ? Icon(widget.prefixIcon,
                          size: normal_200,
                          color: (() {
                            if (widget.errorText != null) {
                              return Theme.of(context).errorColor;
                            } else {
                              return (_iconColor ??
                                  Theme.of(context).textTheme.bodyText2!.color);
                            }
                          }()))
                      : null,
                  suffixIcon: (widget.suffixIcon != null)
                      ? GestureDetector(
                          onTap: widget.suffixOnPressed,
                          child: Icon(widget.suffixIcon,
                              size: normal_200,
                              color: (() {
                                if (widget.errorText != null) {
                                  return Theme.of(context).errorColor;
                                } else {
                                  return (_iconColor ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color);
                                }
                              }())),
                        )
                      : null,
                  contentPadding: (widget.maxLines! > 1)
                      ? const EdgeInsets.all(normal_100)
                      : null),
            )));
    if (widget.borderType == BorderType.single) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: normal_100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _editTextContainer,
            if (widget.errorText != null)
              Padding(
                  padding: const EdgeInsets.all(small_50),
                  child: Text(widget.errorText!,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Theme.of(context).errorColor)))
          ],
        ),
      );
    } else {
      return _editTextContainer;
    }
  }
}
*/