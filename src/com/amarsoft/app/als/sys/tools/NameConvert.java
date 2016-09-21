package com.amarsoft.app.als.sys.tools;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.dict.als.cache.NameCache;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 名称转化
 * @author Administrator
 *
 */
public class NameConvert  extends NameManager{

	public static String getOrgNames(String orgs){
		if(orgs==null||orgs.equals("")) return "";
		String orgName="";
		try{
				BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.ORG_INFO);
				if(orgs.endsWith(",")) orgs=orgs.substring(0, orgs.length()-1);
				orgs=StringFunction.replace(orgs, ",", "','");
				List<BizObject> lst=bm.createQuery("orgId in ('"+orgs+"')").getResultList(false); 
				for(BizObject bo:lst){
					orgName+=bo.getAttribute("OrgName").getString()+",";
				}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return orgName;
	}
	
	
	
	/*转换产品名称*/
	public static String getProductNames(String productID){
		if(productID==null||productID.equals("")) return "";
		String productName="";
		try{
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
				if(productID.endsWith(",")) productID=productID.substring(0, productID.length()-1);
				
				productID=StringFunction.replace(productID, ",", "','");
				
				@SuppressWarnings("unchecked")
				List<BizObject> lst = bm.createQuery("PRODUCTID in ('"+productID+"')").getResultList(false); 
				
				for(BizObject bo:lst){
					if(productName.equals("")){
						productName+=bo.getAttribute("PRODUCTNAME").getString();
					}else{
						productName+=","+bo.getAttribute("PRODUCTNAME").getString();
					}
				}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return productName;
	}
	
	public static String getBusinessNames(String typeNos){
		if(typeNos==null||typeNos.equals("")) return "";
		String typeName="";
		try{
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TYPE");
				if(typeNos.endsWith(",")) typeNos=typeNos.substring(0, typeNos.length()-1);
				typeNos=StringFunction.replace(typeNos, ",", "','");
				List<BizObject> lst=bm.createQuery("TypeNo in ('"+typeNos+"')").getResultList(false); 
				for(BizObject bo:lst){
					if(typeName.equals("")){
						typeName+=bo.getAttribute("TypeName").getString();
					}else{
						typeName+=","+bo.getAttribute("TypeName").getString();
					}
				}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return typeName;
	}
	
	public static String getItemNames(String codeNo,String itemNos) throws Exception{
		if(itemNos==null || itemNos.equals("")) return "";
		String[] itemnoarray=itemNos.split(",");
		String itemName="";
		for(String  itemNo:itemnoarray){
			if(itemName.equals("")){
				itemName=NameManager.getItemName(codeNo, itemNo);
			}else{
				itemName=NameManager.getItemName(codeNo, itemNo)+","+itemName;
			}
		}
		return itemName;
	}
	/**
	 * 获得抵押品名称
	 * @param guarantyType
	 * @return
	 * @throws Exception
	 */
	public static String getGuarantyTypeName(String  guarantyType) throws Exception{
		if(StringX.isEmpty(guarantyType)) return "";
		return  NameCache.getName("CMS_COLLATERALTYPE_INFO", "GUARANTYTYPENAME", "GuarantyType", guarantyType);
	}
	
}
