require 'spec_helper'

describe ModelOperations::Core do
  context 'Base' do
    context 'private #dependency' do
      let(:service)      { double('service') }
      let(:dependencies) { { service: service } }
      subject { object_factory(dependencies: dependencies) }

      it 'returns dependency' do
        expect(subject.send(:dependency, :service)).to eq(service)
      end

      it 'raise MissingDependency when dependency missing' do
        expect { subject.send(:dependency, :unknown) }.to raise_error(described_class::MissingDependency)
      end
    end

    context '.kind' do
      context 'setup' do
        [:create, :update, :read, :delete].each do |kind|
          context "#{kind} kind" do
            subject do
              object_factory do
                kind kind
              end
            end

            it "for instance" do
              expect(subject.kind).to eq(kind)
            end
          end
        end

        it 'raise error when kind is unknown' do
          expect { class_factory { kind :bad } }.to raise_error('[ModelOperations] unknown bad kind type.')
        end
      end
    end

    it '#kind default is :read' do
      expect(object_factory.kind).to eq(:read)
    end

    context '.model setup' do
      subject { object_factory { model :fake_model } }
      it 'model for for instance' do
        expect(subject.model).to eq(:fake_model)
      end
    end

    it '#model default raise MissingModel' do
      expect { object_factory.model }.to raise_error(described_class::MissingModel)
    end

    context '#on setup success and/or fail' do
      let(:actions_with_responses) { {} }
      subject { object_factory.on(actions_with_responses) }

      context 'binded_method' do
        let(:actions_with_responses) { { success: :success_method, fail: :fail_method } }
        it ':success_method is assign' do
          expect(subject.send(:actions)[:success]).to eq(:success_method)
        end

        it ':fail_method is assign' do
          expect(subject.send(:actions)[:fail]).to eq(:fail_method)
        end
      end

      context 'block' do
        let(:success_block) { -> {} }
        let(:fail_block)    { -> {} }
        let(:actions_with_responses) { { success: success_block, fail: fail_block } }
        it ':success_method is assign' do
          expect(subject.send(:actions)[:success]).to eq(success_block)
        end

        it ':fail_method is assign' do
          expect(subject.send(:actions)[:fail]).to eq(fail_block)
        end
      end
    end

    context '#on_success' do
      context 'binded_method' do
        subject { object_factory.on_success(:success_method) }

        it ':success_method is assign' do
          expect(subject.send(:actions)[:success]).to eq(:success_method)
        end
      end
      context 'block' do
        let(:success_block) { -> {} }
        subject { object_factory.on_success(success_block) }

        it 'success_block is assign' do
          expect(subject.send(:actions)[:success]).to eq(success_block)
        end
      end
    end

    context '#on_fail' do
      context 'binded_method' do
        subject { object_factory.on_fail(:fail_method) }

        it ':fail_method is assign' do
          expect(subject.send(:actions)[:fail]).to eq(:fail_method)
        end
      end
      context 'block' do
        let(:fail_block) { -> {} }
        subject { object_factory.on_fail(fail_block) }

        it 'fail_block is assign' do
          expect(subject.send(:actions)[:fail]).to eq(fail_block)
        end
      end
    end

    context '#bind_with' do
      subject { object_factory.bind_with(:bind_object) }
      it 'setup bind_object' do
        expect(subject.send(:bind_object)).to eq(:bind_object)
      end
    end

    it '.rescue_from' do
    end
  end

  context 'CRUD' do
    context 'Create' do
      context 'block validation' do
      end
      context 'block custom save' do
      end

      it '#success?' do
      end

      it '#fail?' do
      end

      it '#errors' do
      end
      context 'success call' do
      end
      context 'fail call' do
      end
    end
    context 'Read' do
      context 'block custom read' do
      end
      it '#success?' do
      end
      it '#fail?' do
      end
      it '#errors' do
      end
      context 'success call' do
      end
      context 'fail call' do
      end
    end
    context 'Update' do
      context 'block custom read' do
      end
      context 'block validation' do
      end
      context 'block custom save' do
      end
      it '#success?' do
      end
      it '#fail?' do
      end
      it '#errors' do
      end
      context 'success call' do
      end
      context 'fail call' do
      end
    end
    context 'Delete' do
      context 'block custom read' do
      end
      context 'block custom delete' do
      end
      it '#success?' do
      end
      it '#fail?' do
      end
      it '#errors' do
      end
      context 'success call' do
      end
      context 'fail call' do
      end
    end
  end
end
