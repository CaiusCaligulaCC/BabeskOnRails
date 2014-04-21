ActiveAdmin.register Kuwasys::Course do

  permit_params :name, :description, :max_registration, :registration_enabled,
                :category_id, :schoolyear_id

  filter :registrations, as: :select

  index do
    selectable_column
    column :name
    column :description
    column :max_registration
    column :registration_enabled
    column :category_id
    column :schoolyear_id
    column :user_count do |course|
      course.registrations.count
    end
    actions
  end

  show do |course|
    attributes_table do
      row :name
      row :description
      row :max_registration
      row :registration_enabled
      row :category_id
      row :schoolyear_id
      row :created_at
      row :updated_at
    end


    # puts self.methods

    # columns do
    #   span do
    #   end
    # end

    active_admin_comments
  end

  # Sidebar for show
  sidebar 'Details', only: :show do
    course = Kuwasys::Course.find(params[:id])
    h3 do
      'Dudes'
    end

    div do
      table do
        tbody do
          course.registrations.all.order(:status_id).each do |reg|
            user = reg.user
            tr do
              td do
                if not reg.status.nil?
                  col = kuwasys_status_tag_color reg.status.name
                  span class: "kuwasys_course_status #{col}" do
                    I18n.t("kuwasys.status.#{reg.status.name}")
                  end
                else
                  span class: "kuwasys_course_status" do
                    I18n.t("kuwasys.status.undefined")
                  end
                end
                a href: admin_user_path(user.id) do
                  user.firstname + ' ' + user.lastname
                end
              end
            end
          end
        end
      end
    end
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
