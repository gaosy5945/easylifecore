package com.amarsoft.app.oci.ws.ftp;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class ZipTool {
	public static void unZip(String fileName , String zipLocation) throws IOException {
		File file = new File(fileName);
		ZipInputStream zis = new ZipInputStream(new FileInputStream(file));
		BufferedInputStream bis = new BufferedInputStream(zis);
		ZipEntry zip = null;
		int b = 0;
		while((zip = zis.getNextEntry()) != null) {
			BufferedOutputStream bos = null;
			try {
				File filetemp = new File(zipLocation + "/" +zip.getName());
				FileOutputStream fos = new FileOutputStream(filetemp);
				bos = new BufferedOutputStream(fos);
				while(( b = bis.read()) != -1) {
					bos.write(b);
				}
				bos.flush();
			} finally {
				bos.close();
			}
		}
		zis.close();
	}

}
