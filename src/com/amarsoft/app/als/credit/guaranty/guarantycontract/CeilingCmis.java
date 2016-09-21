package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

/**
 * 名称转化
 * @author wur
 *
 */
public class CeilingCmis{
	//根据合同编号得到押品流水号                                                                                                                                                                                                                                                  
	public static String getAssetSerialno(String sGCSerialNo){      
		if( null == sGCSerialNo || "".equals(sGCSerialNo)) return "";
		StringBuffer AssetSerialno = new StringBuffer();
		String AssetSerialnos = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
			List<BizObject> lst=bm.createQuery("GCSERIALNO=:GCSERIALNO").setParameter("GCSERIALNO", sGCSerialNo).getResultList(false); 
			for(BizObject bo:lst){
					AssetSerialno.append(bo.getAttribute("ASSETSERIALNO").getString()).append(",");
			}
			
			if(StringX.isEmpty(AssetSerialno.toString())||"null".equals(AssetSerialno.toString())||"null"==AssetSerialno.toString()){
			}else{
				AssetSerialnos = AssetSerialno.toString().substring(0,AssetSerialno.toString().length()-1);
				if(StringX.isEmpty(AssetSerialnos) || AssetSerialnos=="null") AssetSerialnos = "";
			}

		}catch(Exception e){
			e.printStackTrace();
		}
		return AssetSerialnos;
	}
	
	//根据合同编号得到担保债权金额                                                                                                                                                                                                                                                  
		public static double getGntCrRtAmt(String sGCSerialNo){                                                                                                                                                                                                                            
			if( null == sGCSerialNo || "".equals(sGCSerialNo)) return 0.0;                                                                                                                                                                                                                    
			double sGntCrRtAmt = 0.0;    
			try{   
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
				BizObject bo = bm.createQuery(" O.objecttype='jbo.guaranty.GUARANTY_CONTRACT' and O.objectno=:GCSerialNo and O.RelativeType='05' ").setParameter("GCSerialNo", sGCSerialNo).getSingleResult(false); 
				if(bo==null){
					sGntCrRtAmt = 0.0;
				} else {
					sGntCrRtAmt = bo.getAttribute("RELATIVEAMOUNT").getDouble();
				}              
			}catch(Exception e){                                                                                                                                                                                                                                                             
				e.printStackTrace();                                                                                                                                                                                                                                                           
			}                                                                                                                                                                                                                                                                                
			return sGntCrRtAmt;                                                                                                                                                                                                                                                              
		} 
		
		//获取核心识别要素
		public static String getAttribute4(String assettype) throws Exception
		{
			String result = "";
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			BizObjectQuery boq = bm.createQuery("select ATTRIBUTE4 from O where  codeno='AssetType' and Itemno=:AssetType");
			boq.setParameter("AssetType", assettype);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("ATTRIBUTE4").getString();
			}		
			return result;
		}

		//获取辅助识别要素
		public static String getAttribute5(String assettype) throws Exception
		{
			String result = "";
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			BizObjectQuery boq = bm.createQuery("select ATTRIBUTE5 from O where  codeno='AssetType' and Itemno=:AssetType");
			boq.setParameter("AssetType", assettype);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("ATTRIBUTE5").getString();
			}		
			return result;
		}
	}

	