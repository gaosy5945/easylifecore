/**
 * ѡ��������ͻ�
 */

function selectCustomer(){
	var sParaString = "UserID"+","+AsCredit.userId;	   
	setObjectValue("SelectPartnerCustomer",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
}

/**
 * ѡ�����ò�Ʒ����ѡ
 */
function selectProduct(){
	
}

/**
 * ѡ�����������ѡ
 */
function selectOrg(){
    sReturn = setObjectValue("SelectAllOrgMulti","","@PARTICIPATEORG@0@PARTICIPATEORGName@1",0,0,"");
}