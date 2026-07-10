import mongoose from "mongoose";
const storyPageSchema=new mongoose.Schema({
    pageNumber:{
        type:Number,
        required:true
    },
    title:{
        type:String,
        required:true
    },
    imageUrl:{
        type:String,
        required:true
    },
    audioUrl:{
        type:String,
        required:true
    },
    content:{
        type:String,
        required:true
    },
});
const storySchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true,
        index: true
    },
    coverImageUrl:{
        type: String,
        required: true
    },
    description:String,
    isPremium: {
        type: Boolean,
        default: true,
        index: true, 
    },
    isVisible: {
        type: Boolean,
        default: true,
        index: true,
    },
    totalPages:{
        type:Number,
        default:0
    },
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        index: true
    },
    pages:[storyPageSchema]
}, { timestamps: true });
storySchema.pre("save", function () {
  this.totalPages = this.pages ? this.pages.length : 0;
});
const Story = mongoose.model("Story", storySchema);
export default Story;