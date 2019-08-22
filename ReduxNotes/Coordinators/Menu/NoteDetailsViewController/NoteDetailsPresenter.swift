extension Actions.NotesView {
    struct Edit: Action {
        let noteId: AllNotes.Id
    }
}


struct NoteDetailsPresenter {
    typealias Props = NoteDetailsViewController.Props
    
    let noteID: AllNotes.Id
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    private(set) weak var router: NoteDetailsRouting?
    
    let endObserving: Command
    
    func present(state: State) {
        guard let note = state.allNotes.byId[noteID] else {
            fatalError("cannot display note for ID: \(noteID)")
        }
        
        render.perform(with: Props(
            title: note.text,
            text: note.text,
            edit: Command { self.router?.edit(noteId: self.noteID) },
            endObserving: Command {
                self.endObserving.perform()
            }
        ))
    }
}
