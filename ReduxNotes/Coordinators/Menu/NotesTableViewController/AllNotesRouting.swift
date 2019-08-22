//
//  AllNotesRouter.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 21/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

protocol AllNotesRouting: class {
    func selectNote(noteId: AllNotes.Id)
    func addNewNote(context: NewNotePresenter.Context)
}
