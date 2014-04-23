ActiveAdmin.register Kuwasys::Category do

  permit_params :name

  menu parent: 'Kuwasys'
end
