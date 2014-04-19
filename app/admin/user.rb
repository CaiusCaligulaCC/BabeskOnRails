ActiveAdmin.register User do
  permit_params :firstname, :lastname, :email, :password, :password_confirmation, :birthday, registrations_attributes:[:user_id, :course_id, :_destroy, :id]

  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :email
    column :birthday
    column :sign_in_count
    column :courses do |user|
      user.registrations.all.map do |reg|
        div do
          if not reg.status.nil?
            status_col = kuwasys_status_tag_color reg.status.name
            span class: "status_tag #{status_col}" do
                I18n.t("kuwasys.status.#{reg.status.name}")
            end
          end
          span do reg.course.name end
        end
      end.join(', ')
    end
    actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs 'Courses' do
      f.has_many :registrations,
                  heading: '',
                  new_record: 'Add to course',
                  allow_destroy: true do |reg|
        reg.input :course_id, label: 'Course', as: :select,
                      collection: Kuwasys::Course.all
      end
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete :password
        params[:user].delete :password_confirmation
      end
      if !params[:user][:registrations_attributes].nil?
        params[:user][:registrations_attributes].each do |i, reg|
          reg[:user_id] = params[:id].to_i
        end
      end
      super
    end
  end

end
