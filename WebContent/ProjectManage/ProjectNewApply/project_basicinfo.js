/**
 * 选择合作方客户
 */

function selectCustomer(){
	var sParaString = "UserID"+","+AsCredit.userId;	   
	setObjectValue("SelectPartnerCustomer",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
}

/**
 * 选择适用产品，多选
 */
function selectProduct(){
	
}

/**
 * 选择共享机构，多选
 */
function selectOrg(){
    sReturn = setObjectValue("SelectAllOrgMulti","","@PARTICIPATEORG@0@PARTICIPATEORGName@1",0,0,"");
}