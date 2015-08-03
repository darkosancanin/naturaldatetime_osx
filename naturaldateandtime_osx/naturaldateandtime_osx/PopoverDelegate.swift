import Cocoa

protocol PopoverDelegate
{
    func resizeToHeight(height: CGFloat)
    func closePopover(sender: AnyObject?)
}
