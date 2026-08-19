{ config }:

''
  cursor {
      xcursor-theme "${config.stylix.cursor.name}"
      xcursor-size ${toString config.stylix.cursor.size}
  }
''
