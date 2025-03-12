class BooleanInput < SimpleForm::Inputs::BooleanInput
    def label_text
        " " + super
    end
end