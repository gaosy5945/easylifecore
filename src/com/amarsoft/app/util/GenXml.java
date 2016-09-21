package com.amarsoft.app.util;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

public class GenXml {
	private  String XmlHead="<Item Id=\"root\" Text=\"@objectno@\" NodeStyle=\"Normal\" Type=\"Dir\" ScanTime=\"\" ScanCount=\"-1\">ReplaceBody</Item>";
	private  String Body="<Item Id=\"@id@\" Text=\"@Text@\" NodeStyle=\"Normal\" Type=\"Dir\" ScanTime=\"\" ScanCount=\"0\">ReplaceElement</Item>";
	private  String ElementNormal="<Item Id=\"@id@\" Text=\"@Text@\" NodeStyle=\"Normal\" Type=\"Dir\" ScanTime=\"\" ScanCount=\"-1\"></Item>";
	private  String ElementAdd="<Item Id=\"@id@\" Text=\"@Text@\" NodeStyle=\"Add\" Type=\"Dir\" ScanTime=\"\" ScanCount=\"-1\"></Item>";
	private  Map<String,String> mapIdtoFoldname;//id与foldername的映射
	private  Map<String,String> mapIdtoFilename;//id与filename的映射
	private  List<String> list= null;
		private void InitMap() throws SQLException{
			BizObjectManager bm;
			String fileId="";
			String foldName="";
			String FileName = "";
			mapIdtoFoldname = new HashMap<String, String>();
			mapIdtoFilename = new HashMap<String, String>();
			list  = new ArrayList<String>();
			try {
				bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
				String sql="SELECT O.FILENAME ,DVF.FILEID ,DVC.FOLDERNAME "
						+ " FROM O,jbo.doc.DOC_VIEW_FILE DVF, jbo.doc.DOC_VIEW_CATALOG DVC"
						+ " WHERE O.FILEFORMAT = '03'"
						+ " AND O.IMAGEFILEID IS NOT NULL AND O.FILEID"
						+ " = DVF.FILEID AND DVF.VIEWID = DVC.VIEWID order by DVC.FOLDERNAME desc";		
			
				List<BizObject> listSql = bm.createQuery(sql).getResultList(false);
				for (BizObject bizObject : listSql) {
					
						
					fileId = bizObject.getAttribute("fileid").toString().trim();
					foldName = bizObject.getAttribute("foldername").toString().trim();
					FileName = bizObject.getAttribute("filename").toString().trim();
					if(!(list.contains(foldName))){
						list.add(foldName);
					}
					mapIdtoFoldname.put(fileId, foldName);
					mapIdtoFilename.put(fileId, FileName);
				}
			
			} catch (JBOException e) {
				e.printStackTrace();
			}
		
		}
//		public static String GenXml(String objectno) throws SQLException{
//			InitMap();
//			BizObjectManager bm;
//			String fileId="";
//			String foldName="";
//			String status = "";
//			List<String>listStatus = new ArrayList<String>(); 			
//			try {
//				bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
//				List<BizObject> listSql = bm.createQuery("select * from O where objectno=:objectno").setParameter("objectno", objectno).getResultList(false);
//				for (int i = 0; i < list.size(); i++) {
//					GenBody(new Integer(i).toString(),list.get(i).substring(0, 1),list.get(i));
//				};
//				for (BizObject bizObject : listSql) {
//					status = bizObject.getAttribute("status").toString().trim();
//					listStatus.add(status);
//				}
//				if(listStatus.contains("03")&&listStatus.contains("02")){//补扫					
//					for (BizObject bizObject : listSql) {
//						status = bizObject.getAttribute("status").toString().trim();
//						fileId = bizObject.getAttribute("fileid").toString().trim();						
//						foldName = mapIdtoFoldname.get(fileId);
//						if("03".equals(status)){//原来就有的
//							GenElement(list.indexOf(foldName)+"", fileId, mapIdtoFilename.get(fileId),"Normal");
//						}else{// 补扫的
//							GenElement(list.indexOf(foldName)+"", fileId, mapIdtoFilename.get(fileId),"Add");
//						}
//					}
//				}else{//新增
//					for (BizObject bizObject : listSql) {
//						fileId = bizObject.getAttribute("fileid").toString().trim();						
//						foldName = mapIdtoFoldname.get(fileId);
//						if("02".equals(status)){
//							GenElement(list.indexOf(foldName)+"", fileId, mapIdtoFilename.get(fileId),"Normal");
//						}						
//					}
//				}
//				
//				XmlHead = XmlHead.replaceAll("@objectno@", objectno);
//					clear();					
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return XmlHead;	
//			
//		}
		
		
		/**
		 * 
		 * @param objectno
		 * @param Status
		 * @param flag 是否已有上传影像
		 * @return
		 * @throws SQLException
		 */
		
		public String GenXml(String objectno,String Status,boolean flag) throws SQLException{
			InitMap();
			BizObjectManager bm;
			String fileId="";
			String foldName="";
			List<String>listStatus = new ArrayList<String>(); 			
			try {
				bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
				
				List<BizObject> listSql = bm.createQuery("select O.* from O,jbo.doc.DOC_VIEW_FILE DVF, jbo.doc.DOC_VIEW_CATALOG DVC where O.ObjectNo=:objectno and O.ObjectType='contract' and O.Status=:Status and O.FILEID = DVF.FILEID AND DVF.VIEWID = DVC.VIEWID AND O.fileformat = '03' order by DVC.FOLDERNAME desc,o.FILEID").setParameter("objectno", objectno).setParameter("Status", Status).getResultList(false);
				for (int i = 0; i < list.size(); i++) {
					GenBody(new Integer(i).toString(),list.get(i).substring(0, 1),list.get(i));
				};
				
				for (BizObject bizObject : listSql) {
					fileId = bizObject.getAttribute("fileid").toString().trim();						
					foldName = mapIdtoFoldname.get(fileId);
					String nodeStyle = "Normal";
					if(flag && "02".equals(bizObject.getAttribute("Status").getString()))
					{
						nodeStyle = "Add";
					}
					GenElement(list.indexOf(foldName)+"", fileId, mapIdtoFilename.get(fileId),nodeStyle);
				}
				
				
				XmlHead = XmlHead.replaceAll("@objectno@", objectno);
					clear();					
			} catch (Exception e) {
				e.printStackTrace();
			}
			return XmlHead;	
			
		}
		
		
		
		private String GenElement(String bodyId,String id,String Text,String Style){
			if("Normal".equals(Style)){
				XmlHead=XmlHead.replace("ReplaceElement"+bodyId, "ReplaceElement"+bodyId+ElementNormal)
						.replace("@id@", id).replace("@Text@", Text);
			}else if("Add".equals(Style)){
				XmlHead=XmlHead.replace("ReplaceElement"+bodyId, "ReplaceElement"+bodyId+ElementAdd)
						.replace("@id@", id).replace("@Text@", Text);
			}
		
			return XmlHead;
		}
		private String GenBody(String bodyId,String id,String Text){//>ReplaceBody<换成>ReplaceBody<>ReplaceElement+BodyId<>		   	
		   		XmlHead=XmlHead.replace("ReplaceBody", "ReplaceBody"+Body.replace("ReplaceElement", "ReplaceElement"+bodyId))
						.replace("@id@", id).replace("@Text@", Text);		   
			return XmlHead;
		}
		private void clear(){
			XmlHead = XmlHead.replaceAll(">Replace\\w+<", "><");
		}
}
