  // Create Default stems
stems = getStems("nl:surfnet:diensten")
if (stems.size() == 0) {  addRootStem("nl","nl"); addStem("nl","surfnet","surfnet");  addStem("nl:surfnet","diensten","diensten"); }
