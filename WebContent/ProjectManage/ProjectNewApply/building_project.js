/**
 *����¥����Ϣ
 */
function newBuilding(){
	var BuildingSerialNo = getItemValue(0,0,"BUILDINGSERIALONO");
	AsCredit.openFunction("BuildingInfo", "BuildingSerialNo = "+BuildingSerialNo,"","_self");
}
/**
 *�鿴¥����Ϣ����
 */
function viewBuilding(){
	var BuildingSerialNo = getItemValue(0,0,"BUILDINGSERIALONO");
	AsCredit.openFunction("BuildingInfo", "BuildingSerialNo = "+BuildingSerialNo,"","_self");
}
/**
 *ɾ��ѡ��¥����Ϣ
 */
function deleteBuilding(){
	
}
