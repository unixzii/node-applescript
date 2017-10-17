{
  "targets": [
    {
      "target_name": "applescript_2",
      "sources": [ "src/applescript_2.cc", "src/osa.mm" ],
      "include_dirs": [
        "<!(node -e \"require('nan')\")"
      ],
      "libraries": [
        "-framework Cocoa"
      ]
    }
  ]
}
