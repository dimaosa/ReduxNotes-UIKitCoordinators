import UIKit

extension Actions.NotesView {
    struct CommonNotesUpdated {}
}

struct CommonNotesTablePresenter {
    typealias Props = AllNotesTableViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    private(set) weak var router: AllNotesRouting?
    
    let endObserving: Command
    
    func present(state: State) {
        let notes = state.allNotes.byId.filter({ $0.value.context == .common }).map { note -> Props.Note in
            return Props.Note(
                title: note.value.text,
                select: Command { self.router?.selectNote(noteId: note.key) },
                delete: dispatch.bind(to: Actions.Notes.Delete(noteId: note.key))
            )
        }
        
        let props = Props(
            title: "Common Notes",
            notes: notes,
            addNewNote: Command { self.router?.addNewNote(context: .personal) },
            endObserving: Command {
                self.endObserving.perform()
            }
        )
        
        render.perform(with: props)
    }
}

