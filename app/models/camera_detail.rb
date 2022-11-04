class CameraDetail < ApplicationRecord
  belongs_to :user

  enum camera_type: {
    "iPhone" => 0,
    "Digital Camera" => 1,
    "Film Camera" => 2,
    "8mm" => 3,
    "Polaroid" => 4,
    "Camcorder" => 5
  }
end
