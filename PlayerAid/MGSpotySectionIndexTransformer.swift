import Foundation

/** 
 MGSpotyViewController library indexes start with 1, ours start from 0
 */
final class MGSpotySectionIndexTransformer {
    func zeroBasedSectionIndex(spotyVCSectionIndex: Int) -> Int {
        let index = spotyVCSectionIndex
        assert(index != 0)
        return index - 1
    }
    
    func zeroBasedIndexPath(spotyVCIndexPath: NSIndexPath) -> NSIndexPath {
        let sectionIndex = zeroBasedSectionIndex(spotyVCIndexPath.section)
        return NSIndexPath(forRow: spotyVCIndexPath.row, inSection: sectionIndex)
    }
}
