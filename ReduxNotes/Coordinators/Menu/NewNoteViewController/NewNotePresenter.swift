
struct NewNotePresenter {
    typealias Props = NewNoteViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    private(set) weak var router: NewNoteRouting?
    
    let endObserving: Command
    
    let context: Context
    
    enum Context: String, Codable {
        case personal, common
    }
    
    func present(state: State) {
        
        func saveAction() -> Action? {
            guard state.newNote.text.count > 0 else { return nil }
            return Actions.Notes.AddNote(text: state.newNote.text, context: context)
        }
        
        let props = Props(
            title: "New Note",
            text: state.newNote.text,
            updateText: dispatch.map(transform: Actions.Notes.UpdateNewNoteText.init),
            cancel: Command {
                self.dispatch.perform(with: Actions.Notes.ClearNewNote())
                self.router?.dismiss()
            },
            save: Command {
                if let action = saveAction() {
                    self.dispatch.perform(with: action)
                    self.dispatch.perform(with: Actions.Notes.ClearNewNote())
                    self.router?.dismiss()
                }
            },
            endObserving: Command { self.endObserving.perform() }
        )
        
        render.perform(with: props)
    }
}
