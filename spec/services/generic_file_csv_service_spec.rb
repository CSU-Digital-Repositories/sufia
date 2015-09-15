require 'spec_helper'

describe Sufia::GenericFileCSVService do
  let(:file) do
    GenericFile.new(id: '123abc', title: ['My Title'], creator: ['Von, Creator'],
                    resource_type: ['Book', 'Other'], rights: ['Mine'], mime_type: 'application/pdf') do |f|
      f.apply_depositor_metadata('jilluser@example.com')
    end
  end

  context "when using the defaults" do
    let(:csv_service) { described_class.new(file) }

    describe "csv" do
      subject { csv_service.csv }

      it { is_expected.to eq "123abc,My Title,jilluser@example.com,\"Von, Creator\",restricted,Book|Other,Mine,pdf\n" }
      it "parses as valid csv" do
        expect(CSV.parse(subject)).to eq([["123abc", "My Title", "jilluser@example.com", "Von, Creator", "restricted", "Book|Other", "Mine", "pdf"]])
      end
    end

    describe "csv_header" do
      subject { csv_service.csv_header }
      it { is_expected.to eq "id,title,depositor,creator,visibility,resource_type,rights,file_format\n" }
    end
  end

  context "when specifying terms" do
    let(:csv_service) { described_class.new(file, [:id, :title, :resource_type]) }
    describe "csv" do
      subject { csv_service.csv }
      it { is_expected.to eq "123abc,My Title,Book|Other\n" }
    end
    describe "csv_header" do
      subject { csv_service.csv_header }
      it { is_expected.to eq "id,title,resource_type\n" }
    end
  end

  context "when specifying separator" do
    let(:csv_service) { described_class.new(file, nil, '&&') }
    describe "csv" do
      subject { csv_service.csv }

      it { is_expected.to eq "123abc,My Title,jilluser@example.com,\"Von, Creator\",restricted,Book&&Other,Mine,pdf\n" }
    end

    describe "csv_header" do
      subject { csv_service.csv_header }
      it { is_expected.to eq "id,title,depositor,creator,visibility,resource_type,rights,file_format\n" }
    end
  end

  context "when specifying terms and separator" do
    let(:csv_service) { described_class.new(file, [:id, :title, :resource_type], '*$*') }
    describe "csv" do
      subject { csv_service.csv }
      it { is_expected.to eq "123abc,My Title,Book*$*Other\n" }
    end
    describe "csv_header" do
      subject { csv_service.csv_header }
      it { is_expected.to eq "id,title,resource_type\n" }
    end
  end
end
