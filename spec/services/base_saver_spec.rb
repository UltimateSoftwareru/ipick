require 'rails_helper'

RSpec.describe BaseSaver do
  subject { BaseSaver }

  let(:params) do
    {"data"=>
      {"attributes"=>{"name"=>"name"},
       "from_address"=>
        {"data"=>{"attributes"=>{"name"=>"name"}, "type"=>"addresses"}},
       "addresses"=>
        [{"data"=>{"attributes"=>{"name"=>"name"}, "type"=>"addresses"}}],
       "type"=>"orders"}}
  end

  let(:options) do
    { name: "name" }
  end

  let(:permitted) { %i(name) }

  let(:address) { build(:address) }

  let(:belongs_to_relation) { :from_address }

  let(:has_many_relation) { :addresses }

  let(:parent) do
    build(:order,
      from_address: address,
      addresses: [address])
  end

  describe :parse do
    context "does nothing if" do
      it "there are no options passed" do
        allow_any_instance_of(subject).to receive(:options).and_return(nil)
        expect(options).to_not receive(:is_a?)
      end

      it "there are no parent passed" do
        allow_any_instance_of(subject).to receive(:parent).and_return(nil)
        expect(options).to_not receive(:is_a?)
      end
    end

    context "deals with array of options" do
      after(:each) do
        subject.new(params, parent, has_many_relation).parse
      end

      it "iterates over array of options, destroys all existing related records and creates new from options" do
        allow_any_instance_of(subject).to receive(:options).and_return(params["data"][has_many_relation.to_s])
        allow_any_instance_of(subject).to receive(:permitted).and_return(permitted)
        allow(parent).to receive(has_many_relation)
        expect(parent).to receive_message_chain("#{has_many_relation}.delete_all")
        expect(parent).to receive_message_chain("#{has_many_relation}.create").with(options)
      end
    end

    context "deals with options hash" do
      after(:each) do
        subject.new(params, parent, belongs_to_relation).parse
      end

      it "creates new belongs to related object if related object is nil" do
        allow_any_instance_of(subject).to receive(:options).and_return(params["data"][belongs_to_relation.to_s])
        allow(parent).to receive(belongs_to_relation).and_return(nil)
        allow_any_instance_of(subject).to receive(:permitted).and_return(permitted)
        expect(parent).to receive("create_#{belongs_to_relation}").with(options)
      end

      it "updates belongs to related object if related object is present" do
        allow_any_instance_of(subject).to receive(:options).and_return(params["data"][belongs_to_relation.to_s])
        allow(parent).to receive(belongs_to_relation).and_return(address)
        allow_any_instance_of(subject).to receive(:permitted).and_return(permitted)
        expect(parent).to receive_message_chain("#{belongs_to_relation}.update").with(options)
      end
    end
  end
end
