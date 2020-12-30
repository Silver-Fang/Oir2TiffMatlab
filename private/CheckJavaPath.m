function CheckJavaPath()
try
	loci.formats.in.FakeReader;
catch
	JcpPath=fullfile(prefdir,"javaclasspath.txt");
	%只有此编码方案能被正确读取
	Fid=fopen(JcpPath,"at","n","GB18030");
	fprintf(Fid,replace(fullfile(fileparts(mfilename("fullpath")),"BioFormats.jar"),"\","\\")+"\n");
	fclose(Fid);
	error("未将BioFormats.jar加入Java路径。已自动添加到"+JcpPath+"，请重启MATLAB");
end
end

