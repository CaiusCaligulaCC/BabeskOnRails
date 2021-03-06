ActiveAdmin.register User do

  permit_params :firstname, :lastname, :email, :password,
    :password_confirmation, :birthday,
    registrations_attributes: [
      :user_id, :course_id, :status_id, :_destroy, :id
    ]

  remove_filter :statuses

  scope I18n.t('activeadmin.scope.user.all_users'), :all_users, default: true
  scope I18n.t('activeadmin.scope.user.not_registered'), :not_registered
  scope I18n.t('activeadmin.scope.user.only_registered'), :only_registered

  # action_item do
  #   link_to "Dashboard", "/admin/user_dashboard", class: :button
  # end

  index do

    # panel 'options' do
    # div do
    #   'aschaskoldjsd'
    #   link_to 'asdf', '/', class: :button
    # end
    # end

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
            span class: "kuwasys_course_status #{status_col}" do
                I18n.t("kuwasys.status.#{reg.status.name}")
            end
          else
            span class: "kuwasys_course_status" do
                I18n.t("kuwasys.status.undefined")
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
        reg.input :status_id, label: 'Status', as: :select,
                      collection: Kuwasys::Status.all
      end
    end
    f.actions
  end

  controller do
    # Allow passwords to be blank and if so, dont update them
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
