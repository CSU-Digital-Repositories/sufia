require 'spec_helper'

describe 'batch_edits/edit.html.erb' do
  let(:generic_work) { stub_model(GenericWork, id: nil, depositor: 'bob', rights: ['']) }
  let(:form) { double }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    allow(form).to receive(:model).and_return(generic_work)
    allow(form).to receive(:names).and_return(['title 1', 'title 2'])
    allow(form).to receive(:terms).and_return([:description, :rights])
    assign :form, form
    view.lookup_context.view_paths.push "#{CurationConcerns::Engine.root}/app/views/curation_concerns/base"
    render
  end
end
