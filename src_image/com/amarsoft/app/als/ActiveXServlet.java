package com.amarsoft.app.als;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.amarsoft.app.contentmanage.Content;
import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.DefaultContentManagerImpl;
import com.amarsoft.app.contentmanage.action.ContentManagerAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.webservice.util.CodeTrans;


public class ActiveXServlet  extends HttpServlet{
	public ActiveXServlet(){
		ARE.getLog().debug("����ActiveXServlet");
	}
	
	//��������ͼƬ�ļ����е����ڸ�ʽ
	private SimpleDateFormat fileNameDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	//����ͼƬ�����ڸ�ʽ
	private SimpleDateFormat insertPicDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	

	private static final long serialVersionUID = 332233L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("======");
		doPost(req, resp);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("======");
		//String objType, String objNo, String typeNo, String ids
		String ids =  req.getParameter("Ids");
		String objectType =  req.getParameter("ObjectType");
		String objectNo =  req.getParameter("ObjectNo");
		String typeNo =  req.getParameter("TypeNo");
		
		String images =  req.getParameter("Images");
		String userId =  req.getParameter("UserId");
		String orgId =  req.getParameter("OrgId");
		String method = req.getParameter("Method");
		String imageType = req.getParameter("ImageType");

		String str = null;
		
		if(ids != null ){ //�ǻ�ȡͼƬ
			str = getImage( ids);
			//resp.setContentType("text/plain");
		}else if(images != null){ //���ϴ�ͼƬ
			if("Trans".equals(method)){
				ARE.getLog().info("��ʼ����ɨ���"+objectNo+"���µ�Ӱ�����ϣ�");
				//����ɨ��
				str = transImageNew(userId,orgId,images,imageType,objectNo,objectType,typeNo);
			}else{
				//��ɨ����ͼƬ
				str = saveImage(objectType, objectNo, typeNo, images, userId, orgId);
			}
		}
		resp.getWriter().write(str!=null?str:"");
		resp.getWriter().flush();
		resp.getWriter().close();
		System.gc();
		
		
	}
	/**
	 * 
	 * @param userID
	 * @param orgID
	 * @param images
	 * @param imageType
	 * @param objectNo
	 * @return
	 */
	public String transImageNew(String userID,String orgID,String images,String imageType,String objectNo,String objectType,String typeNo){
		System.out.println("=======transImageNew=======");
		Runtime rt = Runtime.getRuntime();
		System.out.println("��ʼ����ɨ��Ӱ���ڴ�����:"+rt.totalMemory()+"���ڴ�ʣ�ࣺ"+rt.freeMemory());
		String[] imgs = images.split("\\|");
		String imageInfo = "batchScan";//local/scan/batchScan/barCode
		String ObjectNo=objectNo,ObjectType=objectType,ImageType=typeNo;
		Connection conn = null;
		Transaction Sqlca = null;
		String dataSource = "oradb";
		try {
			Sqlca = new Transaction(dataSource);
		} catch (Exception e) {
			ARE.getLog().error("���awe config�е�datasource���ó���", e);
		}
		for(int i = 0;i<imgs.length;i++){
			
			batchSaveImage(ObjectType, ObjectNo, ImageType, imgs[i], userID, orgID, imageType, imageInfo,Sqlca,conn);
			System.gc();
			System.out.println("����ɨ��Ӱ��������ڴ�����:"+rt.totalMemory()+"���ڴ�ʣ�ࣺ"+rt.freeMemory());
			
		}
		try {
			if (conn != null) conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "Finish";
	}
	/*
	*//**
	 * ��������Ӱ��ͼƬ����¼��ϵͳ
	 * @param userID
	 * @param orgID
	 * @param images
	 * @param imageType
	 * @return
	 *//*
	public String transImage(String userID,String orgID,String images,String imageType){
		String[] imgs = images.split("\\|");
		String barCodeNo = "";
		String imageInfo = "batchScan";//local/scan/batchScan/barCode
		String ObjectNo="UnKnow",ObjectType="UnKnow",ImageType="UnKnow";
		for(int i = 0;i<imgs.length;i++){
			imageInfo = "batchScan";
			ObjectNo = "UnKnow";
			ObjectType = "UnKnow";
			ImageType = "UnKnow";
			try{
				byte[] b = CodeTrans.String2Byte(imgs[i].replace(" ", "+"));
				InputStream is = new ByteArrayInputStream(b);
				String s = QRUtil.read(is);
				s = "2014081900000008";
				if(s!=null && !"".equals(s)){
					barCodeNo = s;
					//ʶ��������
					imageInfo = "batchScan";
					ARE.getLog().debug("��ȡ�������룺"+s);
					ARE.getLog().debug("��ʼ�洢������Ӱ������...");
					
					try{
						Connection conn = null;
						PreparedStatement ps=null;
						ResultSet rs = null;
						String dataSource = "oradb";
						try {
							conn = ARE.getDBConnection(dataSource);
							conn.setAutoCommit(false);
						} catch (Exception e) {
							ARE.getLog().error("���awe config�е�  ���ó���", e);
						}
						//���Ҹ���������ˮ���Ƿ��ڼ�¼����
						ps = conn.prepareStatement("select * from IMAGE_CODE_INFO where serialNo = ? ");
						ps.setString(1, barCodeNo);
						rs = ps.executeQuery();
						if(rs==null){
							ARE.getLog().warn("δ�ҵ�������"+barCodeNo+"�������Ϣ���޷�������Ӱ����й���");
							barCodeNo = "";
							ObjectNo = "UnKnow";
							ObjectType = "UnKnow";
							ImageType = "UnKnow";
						}else{
							if (rs.next()){
								ObjectNo = rs.getString("ObjectNo");
								ObjectType = rs.getString("ObjectType");
								ImageType = rs.getString("ImageType");
							}
							rs.close();
						}
						ps.close();
					}catch(Exception e){
						ARE.getLog().warn("��ȡͼƬ��Ϣ����");
					}
				}
			}catch(Exception e){
			}
			
			batchSaveImage(ObjectType, ObjectNo, ImageType, imgs[i], userID, orgID, imageType, imageInfo);

		}
		return "Finish";
	}*/
	
	/**
	 * ��������Ӱ��ҳ��ͼƬ��ϵͳ
	 * @param ObjectType
	 * @param ObjectNo
	 * @param TypeNo
	 * @param image
	 * @param userId
	 * @param orgId
	 * @param pageNum
	 * @param imageType
	 * @param imageInfo
	 * @return
	 */
	public String batchSaveImage(String ObjectType, String ObjectNo, String TypeNo, 
								 String image, String userId, String orgId, 
								 String imageType, String imageInfo,Transaction Sqlca,Connection conn) {
		System.out.println("=======batchSaveImage=======");
		if (!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect))
			return "";
		ContentManager contentManager = ContentManagerAction.getContentManager();
		if (contentManager == null)
			return "";
		String retStr = "Success";

		Content tempContent = null;
		PreparedStatement insertDocPs = null;
		PreparedStatement selectDocPs = null;
		String sSerialno = "";
		int pageNum = 1;
		ResultSet rs = null;
		int sSortNo = 0;
		ResultSet rsSortNo = null;
		PreparedStatement selectSortNo = null;
		
		try {
			//��ˮ��
			sSerialno = DBKeyHelp.getSerialNo("ECM_PAGE","SerialNo",Sqlca);
			if(!"UnKnow".equals(ObjectNo)){
				selectDocPs = conn.prepareStatement("Select Max(PageNum) from ECM_PAGE where ObjectNo=? and ObjectType=? and TypeNo=?");
			}
			selectSortNo = conn.prepareStatement("Select Max(to_number(SortNo)) from ECM_PAGE where ObjectNo=? and ObjectType=?");
			insertDocPs = conn.prepareStatement("insert into ECM_PAGE( objectType, objectNo, typeNo, documentId, pageNum, modifyTime, imageInfo, operateUser, operateOrg, remark, SerialNo, SortNo) "
							+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		} catch (Exception e) {
			ARE.getLog().fatal("����statment����", e);
		}
		
		// ----���ϴ���ͼƬ��Ϣ
		byte[] b = CodeTrans.String2Byte(image.replace(" ", "+"));
		InputStream is = new ByteArrayInputStream(b);
		tempContent = new Content();
		tempContent.setInputStream(is);

		tempContent.setDesc("");
		String randomStr = String.valueOf(Math.random()).substring(2);
		if (randomStr.length() < 8) {
			randomStr += "0000000";
		}
		tempContent.setName(fileNameDateFormat.format(new Date()) + "_"
				+ (randomStr.substring(0, 8)) + ".jpg");
		String uploadDocId = contentManager.save(tempContent,
				ContentManager.FOLDER_IMAGE,ObjectNo);
		
		// 1.��ȡ��ǰ��pageNum---2.�������ݵ�ECM_PAGE��
		try {
			selectDocPs.setString(1, ObjectNo);
			selectDocPs.setString(2, ObjectType);
			selectDocPs.setString(3, TypeNo);
			rs = selectDocPs.executeQuery();
			if(rs.next()){
				//ʵ�ʵ�*��
				pageNum = rs.getInt(1)+1;
			}else{
				//��ʼ��Ϊ��һ��
				pageNum = 1;
			}
			selectSortNo.setString(1, ObjectNo);
			selectSortNo.setString(2, ObjectType);
			rsSortNo = selectSortNo.executeQuery();
			if(rsSortNo.next()){
				sSortNo = rsSortNo.getInt(1) + 10;
			}else{
				sSortNo = 10;
			}
			
			insertDocPs.setString(1, ObjectType);
			insertDocPs.setString(2, ObjectNo);
			insertDocPs.setString(3, TypeNo);
			insertDocPs.setString(4, uploadDocId);
			insertDocPs.setInt(5, pageNum);
			insertDocPs.setString(6, insertPicDateFormat.format(new Date()));
			// ��Ӱ������
			/*
			 * queryTypePs.setString(1, ObjectNo); queryTypePs.setString(2,
			 * TypeNo); typeRs = queryTypePs.executeQuery(); String type = "";
			 * if(typeRs.next()){ type= typeRs.getString(1); } if(typeRs!=null)
			 * typeRs.close(); insertDocPs.setString(7, type);
			 */
			// ��ʱ������ localOrScan
			insertDocPs.setString(7, imageInfo);
			insertDocPs.setString(8, userId);
			insertDocPs.setString(9, orgId);
			insertDocPs.setString(10, "");
			insertDocPs.setString(11, sSerialno);
			insertDocPs.setString(12, String.valueOf(sSortNo));
			insertDocPs.execute();
			conn.commit();
			ARE.getLog().trace("����һ����¼: " + uploadDocId);
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().trace("����Ӱ�����ݼ�¼����!");
		} finally {
			try {
				if(is != null){
					try {
						is.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				if (rs != null)
					rs.close();
				if(rsSortNo != null) rsSortNo.close();
				if (insertDocPs != null)
					insertDocPs.close();
				if(selectDocPs!= null)
					selectDocPs.close();
				if(selectSortNo != null) selectSortNo.close();
			} catch (SQLException e) {
				e.printStackTrace();
				ARE.getLog().error("�ر����ݿ����ӳ���", e);
			}
		}
		ARE.getLog().trace(retStr);
		return retStr;
	}
	
	
	
	/**
	 * ��ȡӰ��ͼƬ
	 * @param ids
	 * @return
	 */
	public String getImage( String ids) {
		System.out.println("========getImage========");
		ARE.getLog().debug(ids);
		if(StringX.isEmpty(ids) ||
				!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
		String[] idArr = ids.split("\\|");
		StringBuffer imageBuf = new StringBuffer();
		for (int i = 0; i < idArr.length; i++) {
			String singleImage = getSingleImage( idArr[i]);
			if(! StringX.isEmpty(singleImage)){
				imageBuf.append(singleImage);
				if( i!=idArr.length-1 ) imageBuf.append("|");
			}
		}
		return imageBuf.toString();
	}
	
	/**
	 * ��ȡ����Ӱ��ͼƬ
	 * @param id
	 * @return
	 */
	public String getSingleImage( String id){
		System.out.println("=====getSingleImage======");
		String singleImageStr="";
		if(StringX.isEmpty(id) ||
				!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
		ContentManager contentManager = ContentManagerAction.getContentManager();
		if(contentManager==null) return "";
		
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		byte[] bytes = new byte[10240];
		
		Content content = contentManager.get(id);
		if(content==null) return "";
		
		InputStream is = content.getInputStream();
		String desc = content.getDesc();
		// ��ȡͼƬ�ֽ�����
		try {
			int k = -1;
			while((k=is.read(bytes))>0){
				bos.write(bytes, 0, k);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try {
				is.close();
			} catch (IOException e) { e.printStackTrace(); }
		}
		// ���ֽ�����Base64����
		BASE64Encoder encoder = new BASE64Encoder();
		if(bos.size()>0) {
			singleImageStr = encoder.encode(bos.toByteArray());
			bos.reset();
		}
		String tempStr = encoder.encode(desc.getBytes());
		//ARE.getLog().trace("*******encoder֮ǰ:"+desc+"\n֮��:"+tempStr);
		return singleImageStr+"^"+tempStr;
	}

	/**
	 * ����Ӱ��ҳ��ͼƬ��ϵͳ
	 * @param ObjectType
	 * @param ObjectNo
	 * @param TypeNo
	 * @param imageAndActiveXids
	 * @param userId
	 * @param orgId
	 * @return
	 * @throws Exception 
	 */
	public String saveImage(String ObjectType, String ObjectNo, String TypeNo, 
			String imageAndActiveXids, String userId, String orgId) {
		System.out.println("====saveImage=====");
		if( 	!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
		ContentManager contentManager = ContentManagerAction.getContentManager();
		if(contentManager==null) return "";
		String retStr = "";
		//ͼƬ��Ϣ��IDs˳���ַ�������Ҫɾ����IDs����ע��Ϣ,������֮��ķָ��
		String S1 = "\\|!";
        //���ͼƬ����id�ķָ��
        String S2 = "\\|";
        //infos�е�ÿ��id��info�ķָ��
        String S3 = "\\^";
        int sSortNo = 0;
		String[] imageStrArr = null;
		String[] activeX_Ids = null, needDelIds=null, infos=null;
		if(! StringX.isEmpty(imageAndActiveXids) ) {
			String[] tempArr = imageAndActiveXids.split(S1, -1);
			ARE.getLog().trace("Ҫ�ϴ���ͼƬ(base64����)*******"+ tempArr[0]);
			ARE.getLog().trace("����и���ͼƬ��ID(��·��)��˳��*******"+ tempArr[1]);
			ARE.getLog().trace("Ҫɾ����ͼƬID(��·��)*******"+ tempArr[2]);
			ARE.getLog().trace("Ҫ���õı�ע*******"+ tempArr[3]);
			imageStrArr=tempArr[0].length()>0?tempArr[0].split(S2):null;
			activeX_Ids = tempArr[1].split(S2, -1);
			needDelIds = tempArr[2].length()>0?tempArr[2].split(S2):null;
			infos = tempArr[3].length()>0?tempArr[3].split(S2):null;
		}
		Content tempContent = null;
		
		Connection conn = null;
		PreparedStatement  updateRemarkPs=null, updatePageNumPs=null, deleteOldDocPs=null, insertDocPs = null;
		ResultSet rs = null;
		Transaction Sqlca = null;
		String sSerialno = "";
		/*String dataSource = "oradb";*/
		String dataSource = "als";
		try {
			dataSource = Configure.getInstance().getConfigure("DataSource");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			ARE.getLog().debug("�޷���ȡDataSource");
			e1.printStackTrace();
		}
		
		PreparedStatement selectDocPs = null;
		
		try {
			Sqlca = new Transaction(dataSource);
			conn = Sqlca.getConnection();
			//��ˮ��
			sSerialno = DBKeyHelp.getSerialNo("ECM_PAGE","SerialNo",Sqlca);
			
			//oracle
			/*selectDocPs = conn.prepareStatement("Select Max(to_number(SortNo)) as SortNo from ECM_PAGE where ObjectNo=? and ObjectType=? ");*/
			selectDocPs = conn.prepareStatement("Select Max(cast(SortNo as unsigned int)) as SortNo from ECM_PAGE where ObjectNo=? and ObjectType=? ");
			
			insertDocPs =conn.prepareStatement("insert into ECM_PAGE( objectType, objectNo, typeNo, documentId, pageNum, modifyTime, imageInfo, operateUser, operateOrg, remark, SerialNo, SortNo) "+
					" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			updateRemarkPs = conn.prepareStatement("update ECM_PAGE set remark=? where documentId=? and objectNo=? ");
			updatePageNumPs = conn.prepareStatement("update ECM_PAGE set pageNum=? where documentId=? and objectNo=? ");
			BASE64Decoder decoder = new BASE64Decoder();
			//----���ϴ���ͼƬ��Ϣ���䱸ע
			for (int i = 0, j=0; imageStrArr!=null && activeX_Ids!=null && i<imageStrArr.length; i++) {
				String[] arr = imageStrArr[i].split(S3, -1);
				byte[] b = CodeTrans.String2Byte(arr[0].replace(" ", "+"));
				InputStream is = new ByteArrayInputStream(b);
				tempContent = new Content();
				tempContent.setInputStream(is);
				String tempImageInfo = "", tempImageFileType = "", tempLocalOrScan = "" ;
				if(arr.length>=3){
					tempImageInfo = new String(decoder.decodeBuffer(arr[1].replace(" ", "+")));
					String[] strs = arr[2].split("@");
					tempLocalOrScan = strs[0];
					tempImageFileType = strs[1];
				}
				tempContent.setDesc(tempImageInfo);
				String randomStr = String.valueOf(Math.random()).substring(2);
				if(randomStr.length()<8){randomStr += "0000000"; }
				tempContent.setName(fileNameDateFormat.format(new Date())+"_"+(randomStr.substring(0,8))+".jpg");
				String uploadDocId = contentManager.save(tempContent, ContentManager.FOLDER_IMAGE ,ObjectNo);
				//��������ͼƬid���»�id˳������activeX_Ids��
				for(int j2=j; j2<activeX_Ids.length; j2++){
					if(StringX.isEmpty(activeX_Ids[j2])) {
						activeX_Ids[j2] = uploadDocId;
						j=j2+1;
						break;
					}
				}
				
				//��ѯ�Ƿ���ͼƬ
				selectDocPs.setString(1, ObjectNo);
				selectDocPs.setString(2, ObjectType);
				rs = selectDocPs.executeQuery();
				if(rs.next()){
					//ʵ�ʵ�*��
					sSortNo = rs.getInt("SortNo")+10;
				}else{
					//��ʼ��Ϊ��һ��
					sSortNo = 10;
				}
				
				//---�������ݵ�ECM_PAGE��
				insertDocPs.setString(1, ObjectType);
				insertDocPs.setString(2, ObjectNo);
				insertDocPs.setString(3, TypeNo);
				insertDocPs.setString(4, uploadDocId);
				insertDocPs.setInt(5, i+1);
				insertDocPs.setString(6, insertPicDateFormat.format(new Date()));
				insertDocPs.setString(7, tempLocalOrScan);
				insertDocPs.setString(8, userId);
				insertDocPs.setString(9, orgId);
				insertDocPs.setString(10, tempImageInfo);
				insertDocPs.setString(11, sSerialno);
				insertDocPs.setString(12, String.valueOf(sSortNo));
				insertDocPs.addBatch();
				ARE.getLog().trace("����һ����¼: "+uploadDocId);
			}
			
			//----��ԭ��ͼƬ�ı�ע���޸�,�������ݹ���ƽ̨�ı�ע
			for(int info_i=0; infos!=null && info_i<infos.length; info_i++){
				String[] info_arr = infos[info_i].split(S3);
				String temp = null;
				if(info_arr.length>=2){
					temp = new String(decoder.decodeBuffer(info_arr[1]));
				}
				ARE.getLog().trace("�����ĵ�����(id:"+info_arr[0]+")��desc: "+ temp);
				contentManager.setDesc(info_arr[0], info_arr.length>=2?temp:"");
				//��δʹ�����ݹ���ƽ̨���򱣴���Ϣ��ECM_PAGE���еı�ע�ֶ�
				if( contentManager instanceof DefaultContentManagerImpl){
					updateRemarkPs.setString(1, info_arr.length>=2?temp:"");
					updateRemarkPs.setString(2, info_arr[0]);
					updateRemarkPs.setString(3, ObjectNo);
					updateRemarkPs.addBatch();
					ARE.getLog().trace("����һ����¼:"+info_arr[0]+ "�ı�ע��Ϣ��"+(info_arr.length>=2?temp:"") );
				}
			}
			
			for(int j=0; needDelIds!=null && j<needDelIds.length; j++){
				contentManager.delete(needDelIds[j]);
			}
			String allIdStr = "";
			for(int i =0; i<activeX_Ids.length; i++){
				allIdStr = allIdStr +",'"+activeX_Ids[i]+"'";
			}
			insertDocPs.executeBatch();
			updateRemarkPs.executeBatch();
			
			if(needDelIds!=null && needDelIds.length>0){
				String tempDelIds = "'";
				for(String id : needDelIds){
					tempDelIds = tempDelIds + id +"','";
				}
				tempDelIds = tempDelIds.substring(0, tempDelIds.length()-2);
				String delSql = "delete from  ECM_PAGE where objectType=? and objectNo=? and typeNo=? and documentId  in("+ tempDelIds +") ";
				ARE.getLog().info(delSql);
				deleteOldDocPs =conn.prepareStatement(delSql);
				deleteOldDocPs.setString(1, ObjectType);
				deleteOldDocPs.setString(2, ObjectNo);
				deleteOldDocPs.setString(3, TypeNo);
				deleteOldDocPs.executeUpdate();
			}
			
			if(activeX_Ids!=null && activeX_Ids.length>0){
				for(int i =0; activeX_Ids!=null && i<activeX_Ids.length; i++){
					if(StringX.isEmpty(activeX_Ids[i])){
						continue;
					}
					updatePageNumPs.setInt(1, i+1);
					updatePageNumPs.setString(2, activeX_Ids[i]);
					updatePageNumPs.setString(3, ObjectNo);
					updatePageNumPs.addBatch();
					ARE.getLog().trace("����"+activeX_Ids[i]+ "�ı��Ϊ"+(i+1));
					retStr = retStr+"|"+activeX_Ids[i];
				}
				updatePageNumPs.executeBatch();
			}
			conn.commit();
			
		} catch (Exception e) {
			ARE.getLog().info("����Ӱ�����ݳ���");
			e.printStackTrace();
			ARE.getLog().error("����Ӱ�����ݳ���", e);
		}finally{
			try {
				if(rs!=null) rs.close();
				if(updateRemarkPs!=null) updateRemarkPs.close();
				if(updatePageNumPs!=null) updatePageNumPs.close();
				if(deleteOldDocPs!=null) deleteOldDocPs.close();
				if(insertDocPs!=null) insertDocPs.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) { ARE.getLog().error("�ر����ݿ����ӳ���",e); }
		}
		retStr = retStr.length()>0?retStr.substring(1):"";
		ARE.getLog().trace(retStr);
		return retStr;
	}
	}

