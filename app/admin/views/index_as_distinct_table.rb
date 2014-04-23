module ActiveAdmin
  module Views
    #
    # Workaround for ActiveAdmin not using the distinct in model-relations.
    # (For example, the -> { distinct } in
    # has_many :statuses, -> { distinct } , through: :registrations
    # will be ignored)
    # Only displays a element once, even if it has many related objects with
    # has_many through
    #
    class IndexAsDistinctTable < ActiveAdmin::Component
      def build(page_presenter, collection)
        table_options = {
          id: "index_table_#{active_admin_config.resource_name.plural}",
          sortable: true,
          class: "index_table index",
          i18n: active_admin_config.resource_class,
          paginator: page_presenter[:paginator] != false,
          row_class: page_presenter[:row_class]
        }

        collection = collection.distinct

        table_for collection, table_options do |t|
          table_config_block = page_presenter.block || default_table
          instance_exec(t, &table_config_block)
        end
      end

      def table_for(*args, &block)
        insert_tag IndexTableFor, *args, &block
      end

      def default_table
        proc do
          selectable_column
          id_column
          resource_class.content_columns.each do |col|
            column col.name.to_sym
          end
          default_actions
        end
      end

      def self.index_name
        "distinct_table"
      end

      #
      # Extend the default ActiveAdmin::Views::TableFor with some
      # methods for quickly displaying items on the index page
      #
      class IndexTableFor < ::ActiveAdmin::Views::TableFor

        # Display a column for checkbox
        def selectable_column
          return unless active_admin_config.batch_actions.any?
          column resource_selection_toggle_cell, class: 'selectable' do |resource|
            resource_selection_cell resource
          end
        end

        # Display a column for the id
        def id_column
          column(resource_class.human_attribute_name(resource_class.primary_key), sortable: resource_class.primary_key) do |resource|
            if controller.action_methods.include?('show')
              link_to resource.id, resource_path(resource), class: "resource_id_link"
            else
              resource.id
            end
          end
        end

        # Add links to perform actions.
        #
        # ```ruby
        # # Add default links.
        # actions
        #
        # # Add default links with a custom column title (empty by default).
        # actions name: 'A title!'
        #
        # # Append some actions onto the end of the default actions.
        # actions do |admin_user|
        #   link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
        # end
        #
        # # Custom actions without the defaults.
        # actions defaults: false do |admin_user|
        #   link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
        # end
        # ```
        #
        def actions(options = {}, &block)
          show_default_links = options.delete(:defaults) { true }
          column options.delete(:name), options do |resource|
            text_node default_actions(resource) if show_default_links
            text_node instance_exec(resource, &block) if block_given?
          end
        end

        def default_actions(*args)
          links = proc do |resource|
            links = ''.html_safe
            if controller.action_methods.include?('show') && authorized?(ActiveAdmin::Auth::READ, resource)
              links << link_to(I18n.t('active_admin.view'), resource_path(resource), class: "member_link view_link")
            end
            if controller.action_methods.include?('edit') && authorized?(ActiveAdmin::Auth::UPDATE, resource)
              links << link_to(I18n.t('active_admin.edit'), edit_resource_path(resource), class: "member_link edit_link")
            end
            if controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, resource)
              links << link_to(I18n.t('active_admin.delete'), resource_path(resource), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}, class: "member_link delete_link")
            end
            links
          end

          options = args.extract_options!
          if options.present? || args.empty?
            actions options
          else
            links.call(args.first)
          end
        end
      end # IndexTableFor

    end
  end
end