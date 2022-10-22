class ImagePickerWeb{
 static ImageType? outputType1;
ImagePickerWeb._();
  static getImage({outputType}){
    outputType1 = outputType;
  }
}
enum ImageType {
  file,
  bytes,
  widget
}