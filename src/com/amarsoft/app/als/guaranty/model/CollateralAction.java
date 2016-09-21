package com.amarsoft.app.als.guaranty.model;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.lang.StringX;

/**
 * @author t-zhangq2
 * ѺƷ��ز���
 */
public class CollateralAction {
	
	//����ѺƷ���ͷ��ض�Ӧ�Ŀ�ѡȨ֤����
	public static String getRightCertSet(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		String str = "jbo.sys.CODE_LIBRARY,ItemNo,ItemName,CodeNo='AssetCertType' and isinuse='1' ",temp = "";
		
		BusinessObject asset = bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		if(asset == null) return str;
		String assetType = asset.getString("AssetType");
		
		List<BusinessObject> codes = bomanager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", "CodeNo='AssetCertType' and Isinuse='1' ");
		
		for(BusinessObject o:codes){
			String attribute1 = o.getString("Attribute1");//���õ�ѺƷ����
			if(!StringX.isEmpty(attribute1)){
				String types[] = attribute1.split(",");
				for(int i = 0;i < types.length;i++){
					if(assetType.startsWith(types[i])){
						String itemNo = o.getString("ItemNo");//Ȩ֤
						temp += "'"+itemNo+"',";
						break;
					}
				}
			}
		}
		
		if(temp.length() > 0){
			temp = temp.substring(0, temp.length()-1);
			str += "and ItemNo in (" + temp +")";
		}
		return str;
	}
}
