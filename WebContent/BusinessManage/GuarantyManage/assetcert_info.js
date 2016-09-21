/**
 * 抵质押登记
 * 
 */

function saveRecord()
{
	as_save();
};


function addStandAssetCert(){
	var dwindex = functionOWMap["CollateralRegister060"];
	//as_add(dwindex);
	ALSObjectWindowFunctions.addRow(dwindex, "", "");
};

function delStandAssetCert(){
	var dwindex = functionOWMap["CollateralRegister060"];
	ALSObjectWindowFunctions.deleteSelectRow(dwindex);
};

function validateStdColl(grSerialNo,assetSerialNo){
	var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", 
			"finishFormalColl", "GRSerialNo="+grSerialNo+",AssetSerialNo="+assetSerialNo);
	if(returnValue=="true"){
		alert("正式抵押完成！");
	}
};