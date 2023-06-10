import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/pages/landing_page/landing_page_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup2_model.dart';
export 'signup2_model.dart';

class Signup2Widget extends StatefulWidget {
  const Signup2Widget({Key? key}) : super(key: key);

  @override
  _Signup2WidgetState createState() => _Signup2WidgetState();
}

class _Signup2WidgetState extends State<Signup2Widget> {
  late Signup2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Signup2Model());

    _model.phoneNumberController ??= TextEditingController();
    _model.myBioController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            title: Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, -0.05),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 4.0),
                        child: FutureBuilder<List<UsersRow>>(
                          future: UsersTable().querySingleRow(
                            queryFn: (q) => q.eq(
                              'id',
                              currentUserUid,
                            ),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              );
                            }
                            List<UsersRow> textUsersRowList = snapshot.data!;
                            final textUsersRow = textUsersRowList.isNotEmpty
                                ? textUsersRowList.first
                                : null;
                            return Text(
                              'Welcome , ${valueOrDefault<String>(
                                textUsersRow?.name,
                                'user',
                              )} : - ) Let\'s make your profile look great !',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    fontSize: 16.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .titleSmallFamily),
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 0.0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Form(
          key: _model.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E3E7),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final selectedMedia =
                                await selectMediaWithSourceBottomSheet(
                              context: context,
                              storageFolderPath: 'users_data/profile_pictures',
                              allowPhoto: true,
                            );
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              setState(() => _model.isDataUploading = true);
                              var selectedUploadedFiles = <FFUploadedFile>[];
                              var downloadUrls = <String>[];
                              try {
                                selectedUploadedFiles = selectedMedia
                                    .map((m) => FFUploadedFile(
                                          name: m.storagePath.split('/').last,
                                          bytes: m.bytes,
                                          height: m.dimensions?.height,
                                          width: m.dimensions?.width,
                                          blurHash: m.blurHash,
                                        ))
                                    .toList();

                                downloadUrls = await uploadSupabaseStorageFiles(
                                  bucketName: 'users_data',
                                  selectedMedia: selectedMedia,
                                );
                              } finally {
                                _model.isDataUploading = false;
                              }
                              if (selectedUploadedFiles.length ==
                                      selectedMedia.length &&
                                  downloadUrls.length == selectedMedia.length) {
                                setState(() {
                                  _model.uploadedLocalFile =
                                      selectedUploadedFiles.first;
                                  _model.uploadedFileUrl = downloadUrls.first;
                                });
                              } else {
                                setState(() {});
                                return;
                              }
                            }

                            await UsersTable().update(
                              data: {
                                'profile_pic_url': valueOrDefault<String>(
                                  _model.uploadedFileUrl,
                                  'https://icons8.com/icon/58565/connect',
                                ),
                              },
                              matchingRows: (rows) => rows,
                            );
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('Message'),
                                  content: Text(
                                      'Your profile picture has been uploaded successfully !'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 90.0,
                            height: 90.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: valueOrDefault<String>(
                                _model.uploadedFileUrl,
                                'https://icons8.com/icon/EInDLGZwVHf7/user',
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    'Upload your profile picture !',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: TextFormField(
                  controller: _model.phoneNumberController,
                  textCapitalization: TextCapitalization.words,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF57636C),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                    hintStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF57636C),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4B39EF),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF5963),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF5963),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF14181B),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  keyboardType: TextInputType.number,
                  validator: _model.phoneNumberControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
                child: FlutterFlowDropDown<String>(
                  controller: _model.genderValueController ??=
                      FormFieldController<String>(null),
                  options: ['Male', 'Female', 'Rather Not say'],
                  onChanged: (val) => setState(() => _model.genderValue = val),
                  width: double.infinity,
                  height: 56.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF14181B),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  hintText: 'Are you a ?',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF57636C),
                    size: 15.0,
                  ),
                  fillColor: Colors.white,
                  elevation: 2.0,
                  borderColor: Color(0xFFE0E3E7),
                  borderWidth: 2.0,
                  borderRadius: 8.0,
                  margin: EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 12.0, 4.0),
                  hidesUnderline: true,
                  isSearchable: false,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    final _datePickedDate = await showDatePicker(
                      context: context,
                      initialDate: getCurrentTimestamp,
                      firstDate: DateTime(1900),
                      lastDate: getCurrentTimestamp,
                    );

                    if (_datePickedDate != null) {
                      setState(() {
                        _model.datePicked = DateTime(
                          _datePickedDate.year,
                          _datePickedDate.month,
                          _datePickedDate.day,
                        );
                      });
                    }
                  },
                  text: valueOrDefault<String>(
                    dateTimeFormat('MMMMEEEEd', _model.datePicked),
                    'Pick your Birthday !',
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.white,
                    textStyle: FlutterFlowTheme.of(context)
                        .headlineSmall
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).headlineSmallFamily,
                          color: Color(0xFF14181B),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).headlineSmallFamily),
                        ),
                    borderSide: BorderSide(
                      color: Color(0xFFE0E3E7),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.05, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(9.0, 9.0, 9.0, 9.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.2, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              13.0, 0.0, 0.0, 0.0),
                          child: AutoSizeText(
                            'Are you a  ',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleMediumFamily),
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.05, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: FlutterFlowChoiceChips(
                            options: [
                              ChipData('Meme Creator',
                                  Icons.design_services_outlined),
                              ChipData('Meme Lover', Icons.favorite)
                            ],
                            onChanged: (val) => setState(
                                () => _model.choiceChipsMCValue = val?.first),
                            selectedChipStyle: ChipStyle(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                              iconColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              iconSize: 18.0,
                              elevation: 4.0,
                            ),
                            unselectedChipStyle: ChipStyle(
                              backgroundColor: Color(0x00000000),
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodySmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodySmallFamily),
                                  ),
                              iconColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              iconSize: 18.0,
                              elevation: 4.0,
                            ),
                            chipSpacing: 10.0,
                            rowSpacing: 12.0,
                            multiselect: false,
                            alignment: WrapAlignment.spaceEvenly,
                            controller: _model.choiceChipsMCValueController ??=
                                FormFieldController<List<String>>(
                              [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
                child: TextFormField(
                  controller: _model.myBioController,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF57636C),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                    hintText: 'Your bio',
                    hintStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF57636C),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4B39EF),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF5963),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF5963),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF14181B),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  validator:
                      _model.myBioControllerValidator.asValidator(context),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await UsersTable().update(
                        data: {
                          'phone_number': _model.phoneNumberController.text,
                          'gender': _model.genderValue,
                          'user_type': _model.choiceChipsMCValue,
                          'bio': _model.myBioController.text,
                          'dob': supaSerialize<DateTime>(_model.datePicked),
                        },
                        matchingRows: (rows) => rows,
                      );
                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          child: LandingPageWidget(),
                        ),
                      );
                    },
                    text: 'Update Profile',
                    options: FFButtonOptions(
                      width: 270.0,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF4B39EF),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).titleMediumFamily),
                          ),
                      elevation: 2.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
