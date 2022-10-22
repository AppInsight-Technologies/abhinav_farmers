
class PlatformViewRegistry{
  registerViewFactory(String app_name, IFrameElement Function(int viewId) param1){
  }
}
final platformViewRegistry = PlatformViewRegistry();
class IFrameElement  {
  String? width;
  String? height;
  String? src;
  bool? allowPaymentRequest;
  var style;
  IFrameElement();
  // To suppress missing implicit constructor warnings.
   IFrameElement._();
  /**
   * Constructor instantiated by the DOM when a custom element has been created.
   *
   * This can only be called by subclasses from their created constructor.
   */
  IFrameElement.created();

}