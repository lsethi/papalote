class DocsController < ApplicationController
  require 'tempfile'

  before_action :set_doc, only: [:show, :update, :destroy, :createDocFile, :deleteDocFile]
  before_action :set_path, only: [:createDocFile, :deleteDocFile]

  def show
    render json: @doc
  end

  def create
    if params['file']
      new_doc =  {
        name: params['file'].original_filename,
        content: params['file'].read
      }
      @doc = Doc.new(new_doc)
    else
      @doc = Doc.new(doc_params)
    end
    respond_to do |format|
      if @doc.save
        format.html { redirect_to @doc, notice: 'Doc was successfully created.' }
        format.json { render :show, status: :created, location: @doc }
      else
        format.html { render :new }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @doc.update(doc_params)
        format.html { redirect_to @doc, notice: 'Doc was successfully updated.' }
        format.json { render :show, status: :ok, location: @doc }
      else
        format.html { render :edit }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @doc.destroy
    respond_to do |format|
      format.html { redirect_to docs_url, notice: 'Doc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def createDocFile
    if !Dir.exists?(@path)
      Dir.mkdir(@path)
    end

    File.open(@path + @doc.name, 'w') { |f| f.write(@doc.content) }
    render json: @doc
  end

  def deleteDocFile
    File.delete(@path + @doc.name)
    render json: @doc
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc
      @doc = Doc.find(params[:id])
    end

    def set_path
      @path = ::Rails.application.config.download_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_params
      params.require(:doc).permit(:name, :content, :folder_id, :owner_id)
    end
end
