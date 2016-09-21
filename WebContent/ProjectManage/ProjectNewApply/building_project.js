/**
 *新增楼盘信息
 */
function newBuilding(){
	var BuildingSerialNo = getItemValue(0,0,"BUILDINGSERIALONO");
	AsCredit.openFunction("BuildingInfo", "BuildingSerialNo = "+BuildingSerialNo,"","_self");
}
/**
 *查看楼盘信息详情
 */
function viewBuilding(){
	var BuildingSerialNo = getItemValue(0,0,"BUILDINGSERIALONO");
	AsCredit.openFunction("BuildingInfo", "BuildingSerialNo = "+BuildingSerialNo,"","_self");
}
/**
 *删除选中楼盘信息
 */
function deleteBuilding(){
	
}
